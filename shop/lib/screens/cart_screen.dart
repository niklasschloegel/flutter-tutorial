import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    void _proceedOrder() {
      setState(() => _isLoading = true);
      Provider.of<Orders>(context, listen: false)
          .addOrder(
        cart.items.values.toList(),
        cart.totalAmount,
      )
          .then((_) {
        cart.clear();
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text("Order placed successfully."),
          ),
        );
      }).catchError((e) {
        print(e);
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text("Something went wrong while placing the order"),
          ),
        );
      }).then((_) => setState(() => _isLoading = false));
    }

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
                        "\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    _isLoading
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed:
                                cart.items.keys.isEmpty ? null : _proceedOrder,
                            child: Text(
                              "ORDER NOW",
                              style: TextStyle(
                                color: cart.items.keys.isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
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
