import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: ChangeNotifierProvider.value(
          value: product,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ChangeNotifierProvider<Product>.value(
                  value: product,
                  child: ProductDetailScreen(),
                ),
              ),
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (_, p, __) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(p.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () async {
                try {
                  final token = auth.token;
                  if (token == null) return;
                  await product.toggleFavorite(token);
                } catch (e) {
                  final scaffMessenger = ScaffoldMessenger.of(context);
                  scaffMessenger.hideCurrentSnackBar();
                  scaffMessenger.showSnackBar(
                    SnackBar(
                      content: Text("Could not change favorite state"),
                    ),
                  );
                }
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added \"${product.title}\" to cart"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
