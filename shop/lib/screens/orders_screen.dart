import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).initOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              else {
                if (dataSnapshot.error != null) {
                  return Center(child: Text("Error, something went wrong :("));
                } else {
                  return Consumer<Orders>(
                    builder: (_, orderData, __) => ListView.builder(
                      itemBuilder: (ctx, i) => OrderItem(
                        key: ValueKey(orderData.orders[i].id),
                        order: orderData.orders[i],
                      ),
                      itemCount: orderData.orders.length,
                    ),
                  );
                }
              }
            },
          ),
        ),
      );
}
