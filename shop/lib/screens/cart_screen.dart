import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalAmount}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "ORDER NOW",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) {
                  final item = cart.items.values.toList()[i];
                  final productId = cart.items.keys.toList()[i];
                  return CartItem(
                    id: item.id,
                    productId: productId,
                    title: item.title,
                    quantity: item.quantity,
                    price: item.price,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
