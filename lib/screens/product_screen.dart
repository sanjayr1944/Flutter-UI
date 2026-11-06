import 'package:demo_http/services/product_service.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

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

  //Initialize State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; //NOT EQUAL TO NULL ? IF ERROR MESSAGE HAS A VALUE WE SHOULD GIVE A RETRY BUTTON
    });

    try
    {
      final products = await _productService.fetchProducts();
      setState(()
      {
        _products = products;
        _isLoading = false;
      });
    }
    catch(e)
    {
      setState(()
      {
        _errorMessage = e.toString();
        _isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Products Catalog"), //Never changing data so use const
      centerTitle: true,
      ),
      body: _buildBody(),

    );
  }


  Widget _buildBody()
  {
    //1.Loading State
    if(_isLoading)
    {
      return Center(child: CircularProgressIndicator(),);
    }

    //2. Error state/Retry Button
    if(_errorMessage != null) //Means It has error
    {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.wifi_off_rounded,size: 64,color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        )
      );
    }

    //3.Empty State
    if(_products.isEmpty)
    {
      return Center(child: Text("No products available."),);
    }

    return RefreshIndicator(onRefresh: _loadProducts,
        child:
    ListView.separated(
        separatorBuilder: (_,_) => Divider(height: 1),
        itemCount: _products.length,
      itemBuilder: (context,index)
      {
        final product = _products[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.thumbnail.isNotEmpty ?
            Image.network(product.thumbnail,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_,__,___) => const Icon(Icons.broken_image),) :
                Icon(Icons.image_not_supported)
          ),
          title: Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text('\₹${product.price.toStringAsFixed(2)}',
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
          ),
          ),
        );
      },
    )
    );
  }
}
