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
  static const String _baseUrl = 'https://dummyjson.com';//Invalid ERROR AND Existing
  final http.Client _client;

  // Optional client injection for unit tests; defaults to standard http.Client
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');

    try {
      final response = await _client.get(
        uri,
        headers: { //The format of data i wanna get and I wanna give it to the server
          'Content-Type': 'application/json', //the type of data i wanna give to the server
          'Accept': 'application/json', //the type of data I wanna get from the server
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