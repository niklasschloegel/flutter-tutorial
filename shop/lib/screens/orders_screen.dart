import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final Future _ordersFuture =
      Provider.of<Orders>(context, listen: false).initOrders();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: FutureBuilder(
            future: _ordersFuture,
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
                    builder: (_, orderData, __) => orderData.orders.length == 0
                        ? Center(
                            child: Text(
                              "No Orders found.",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : ListView.builder(
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
