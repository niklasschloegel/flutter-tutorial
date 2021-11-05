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
  var _isLoading = true;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_isInit) {
      Provider.of<Orders>(context, listen: false).initOrders().catchError((_) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
      }).then((_) {
        setState(() => _isLoading = false);
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(
                  key: ValueKey(orderData.orders[i].id),
                  order: orderData.orders[i],
                ),
                itemCount: orderData.orders.length,
              ),
      ),
    );
  }
}
