import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Consumer<Product>(
            builder: (_, p, __) => IconButton(
              onPressed: product.toggleFavorite,
              icon: Icon(p.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Cart>(context, listen: false)
              .addItem(product.id, product.price, product.title);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Item added to shopping cart")));
        },
        child: Icon(Icons.shopping_cart),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "\$${product.price}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
