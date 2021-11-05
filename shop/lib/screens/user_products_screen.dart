import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProcuts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Products"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, i) {
                  final prod = productsData.items[i];
                  return Column(
                    children: [
                      UserProductItem(prod.id, prod.title, prod.imageUrl),
                      if (i != productsData.items.length - 1) Divider()
                    ],
                  );
                },
                itemCount: productsData.items.length,
              ),
            ),
          ),
        ));
  }
}
