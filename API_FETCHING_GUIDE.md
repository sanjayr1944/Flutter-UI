# Complete Step-by-Step API Fetching Guide in Flutter (with Code for Each File)

This guide provides the complete, production-ready code for every file required to fetch and display REST API data in Flutter using the `http` package, accompanied by detailed explanations of **why** each component, keyword, and line is used.

---

## Project Structure Overview

```text
lib/
├── main.dart                      # Application entry point & root widget
├── models/
│   └── product_model.dart         # Data model & JSON deserialization
├── services/
│   └── product_service.dart       # API network calls & error handling
└── screens/
    └── product_screen.dart        # UI displaying loading, error, and product list
pubspec.yaml                       # Package dependencies
```

---

## 1. `pubspec.yaml` (Dependencies)

### Code:
```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  http: ^1.6.0 # HTTP package for making REST API calls
```

### Why we used this:
- **`dependencies:` vs `dev_dependencies:`**: Network requests are part of the app's production runtime logic, so `http` must be placed under `dependencies`, not `dev_dependencies` (which are only for test runners/linters).
- **`http: ^1.6.0`**: Dart's official cross-platform networking library. Unlike `dart:io`'s `HttpClient` which only works on native platforms, `http` works across Android, iOS, Web, macOS, Windows, and Linux.

---

## 2. `lib/models/product_model.dart` (Data Model Layer)

This file converts raw JSON data received from the API into strongly typed Dart objects.

### Full Code:
```dart
class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String category;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand,
    required this.category,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? 'No Description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      category: json['category'] as String? ?? 'General',
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }
}
```

### Why we used this & that:

1. **Why Model Classes instead of raw `Map`?**
   - Without models, you access data using strings like `product['title']`. If you make a typo like `product['titel']`, the compiler will not warn you, and the app will crash or show blanks at runtime.
   - With models, you write `product.title`. You get **compile-time safety**, **IDE autocompletion**, and painless refactoring.

2. **Why `final` fields?**
   - Immutability prevents accidental state corruption after the data has been parsed from the API.

3. **Why `factory` Constructor (`.fromJson`)?**
   - A standard constructor must instantiate the object directly. A `factory` constructor allows you to perform data processing, safe casting, and validation before returning the final instance.

4. **Why `Map<String, dynamic>`?**
   - In JSON, keys are always text (`String`), but values can be numbers, strings, booleans, nested lists, or objects (`dynamic`).

5. **Why `(json['price'] as num?)?.toDouble() ?? 0.0`?**
   - Backend APIs can send numbers as integers (`10`) or decimals (`10.5`).
   - If you do `json['price'] as double`, it will crash with a `TypeError` whenever the server returns an integer like `10`.
   - Casting to `num?` safely accepts both `int` and `double`, and `.toDouble()` normalizes it to a `double`.
   - The `?? 0.0` provides a fallback value if the key is missing or `null`.

6. **Why `(json['products'] as List<dynamic>? ?? []).map(...).toList()`?**
   - `json['products']` is an untyped list of raw maps.
   - `.map((item) => Product.fromJson(...))` converts every raw map item into a strongly typed `Product` instance.
   - `.toList()` transforms the resulting lazy `Iterable` into a concrete `List<Product>`.
   - `?? []` prevents crashes if the server returns `null` for the products array.

---

## 3. `lib/services/product_service.dart` (Network / Service Layer)

This file handles network requests, query parameters, status code checks, JSON decoding, and network errors.

### Full Code:
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';
  final http.Client _client;

  // Optional client injection for unit tests; defaults to standard http.Client
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Successfully received data
        final Map<String, dynamic> data = jsonDecode(response.body);
        final productResponse = ProductResponse.fromJson(data);
        return productResponse.products;
      } else {
        // Server returned an error (4xx or 5xx)
        throw ApiException(
          'Server returned error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      // No internet connection or DNS lookup failed
      throw ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      // Server took longer than 10 seconds to respond
      throw ApiException('Connection timed out. Please try again.');
    } on FormatException {
      // Response body wasn't valid JSON
      throw ApiException('Bad response format from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to load products: $e');
    }
  }
}
```

### Why we used this & that:

1. **Why `import ... as http`?**
   - Prefixing with `as http` avoids name collisions with classes named `Response`, `Request`, or `Client` that may exist in Flutter or other libraries.

2. **Why `http.Client` & Constructor Injection?**
   - Top-level `http.get()` opens and closes a new TCP connection on every single request.
   - `http.Client()` keeps persistent connections open (HTTP Keep-Alive), speeding up repeated requests.
   - Passing `client` via the constructor allows you to inject a `MockClient` during unit testing without touching the real internet.

3. **Why `Uri.parse(...)`?**
   - Modern `http` methods accept a `Uri` object rather than a raw `String`.
   - `Uri.parse()` properly encodes queries, paths, and characters according to RFC standards.

4. **Why `async` / `await` & `Future<List<Product>>`?**
   - Network requests take time (hundreds of milliseconds).
   - If executed synchronously, the entire UI thread would freeze, preventing user taps and causing frame drops.
   - `async` / `await` frees the main UI thread while waiting for network packets.

5. **Why `headers`?**
   - `'Accept': 'application/json'` informs the server that our app expects JSON back, preventing HTML error responses.
   - `'Content-Type': 'application/json'` tells the server what format we are sending.

6. **Why `.timeout(const Duration(seconds: 10))`?**
   - Default OS network timeouts can take up to 60–120 seconds.
   - Without `.timeout()`, a user on a stalled connection would be stuck on a loading screen indefinitely.

7. **Why check `response.statusCode == 200`?**
   - When an API responds with `404 Not Found` or `500 Server Error`, `http.get` does NOT throw an exception—it still returns a `Response` object.
   - We must explicitly check if the status code is `200` before attempting to decode the payload.

8. **Why `jsonDecode(response.body)`?**
   - `response.body` is simply raw text (`String`).
   - `jsonDecode()` parses the text into Dart `Map` and `List` objects.

9. **Why `on SocketException`, `on TimeoutException`?**
   - Gives users clear, actionable error messages (e.g., *"No internet connection"* vs *"Connection timed out"*).

---

## 4. `lib/screens/product_screen.dart` (UI Layer)

This file manages UI states: **Loading**, **Error (with Retry)**, and **Success (List rendering)**.

### Full Code:
```dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Catalog'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1. Loading State
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error State with Retry Button
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (_products.isEmpty) {
      return const Center(child: Text('No products available.'));
    }

    // 4. Success State with Pull-To-Refresh
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.separated(
        itemCount: _products.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.thumbnail.isNotEmpty
                  ? Image.network(
                      product.thumbnail,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            title: Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 15,
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Why we used this & that:

1. **Why `StatefulWidget` & `initState()`?**
   - `initState()` is called exactly once when the screen enters the widget tree, which is the proper place to trigger the initial API call.
   - If triggered inside `build()`, the network call would re-fire on every single widget rebuild!

2. **Why 3 Explicit UI States (`_isLoading`, `_errorMessage`, `_products`)?**
   - Every network operation has 3 stages:
     - **In-flight**: Show `CircularProgressIndicator`.
     - **Failure**: Show error icon, error description, and a "Try Again" button.
     - **Success**: Render the data list.

3. **Why `RefreshIndicator`?**
   - Enables standard mobile **pull-to-refresh**, allowing users to re-fetch the latest data smoothly.

4. **Why `ListView.separated` instead of `ListView` or `SingleChildScrollView`?**
   - `ListView.separated` lazily builds only the visible items on screen (virtualized list), keeping memory usage low even with thousands of items.

5. **Why `errorBuilder` on `Image.network`?**
   - If an image URL is broken or the network fails while downloading the thumbnail, `errorBuilder` shows a fallback icon instead of throwing an unhandled exception on screen.

---

## 5. `lib/main.dart` (Application Entry Point)

### Full Code:
```dart
import 'package:flutter/material.dart';
import 'screens/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP API Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductScreen(),
    );
  }
}
```

### Why we used this & that:

1. **Why `void main() => runApp(...)`?**
   - `main()` is the Dart entry point. `runApp()` initializes the Flutter engine and attaches the root widget tree to the device screen.
2. **Why `const MyApp()` and `const ProductScreen()`?**
   - `const` allows Flutter to reuse widget instances in memory instead of rebuilding them repeatedly, optimizing performance.
3. **Why `home: const ProductScreen()`?**
   - Sets our newly created `ProductScreen` as the default initial view when the app launches.

---

## 6. HTTP Status Code Quick Reference

| Status Code | Meaning | What to do in Code |
| :--- | :--- | :--- |
| **`200 OK`** | Request succeeded | Safely parse `response.body` with `jsonDecode` |
| **`201 Created`** | Resource created (POST) | Parse the created object |
| **`400 Bad Request`** | Invalid parameters sent | Inform user or validate input parameters |
| **`401 Unauthorized`** | Missing or invalid auth token | Redirect user to Login Screen |
| **`403 Forbidden`** | Authenticated, but lacking permission | Display access denied message |
| **`404 Not Found`** | Endpoint or item doesn't exist | Check URL or report missing item |
| **`500 Server Error`** | Server crashed/unhandled exception | Tell user to try again later |
| **`503 Unavailable`** | Server overloaded or maintenance | Show maintenance message |
