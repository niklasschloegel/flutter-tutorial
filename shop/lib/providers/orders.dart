import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import "package:http/http.dart" as http;

import '../config.dart';

class OrderItem {
  String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  String toJSON() => json.encode({
        "amount": amount,
        "products": products
            .map((e) => {
                  "id": e.id,
                  "price": e.price,
                  "quantity": e.quantity,
                  "title": e.title,
                })
            .toList(),
        "dateTime": dateTime.millisecondsSinceEpoch,
      });
}

class Orders with ChangeNotifier {
  final url = "${Config.serverUrl}/orders";

  List<OrderItem> _orders = [];
  late final String _authToken;

  Orders(this._orders);

  set authToken(token) => _authToken = token;

  List<OrderItem> get orders => [..._orders];

  Future<void> initOrders() async {
    var _newOrders = <OrderItem>[];
    return http.get(Uri.parse("$url.json?auth=$_authToken")).then((res) {
      final body = json.decode(res.body) as Map<String, dynamic>?;
      if (body == null) return;
      body.forEach((id, data) {
        final cartItems = (data["products"] as List<dynamic>)
            .map((productsMap) => CartItem(
                id: productsMap["id"],
                title: productsMap["title"],
                quantity: productsMap["quantity"],
                price: productsMap["price"]))
            .toList();

        _newOrders.add(
          OrderItem(
            id: id,
            amount: data["amount"],
            products: cartItems,
            dateTime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
          ),
        );
      });
      _orders = _newOrders;
    }).catchError((err) {
      print(err);
      throw err;
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final newOrder = OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now());

    return http
        .post(Uri.parse("$url.json?auth=$_authToken"), body: newOrder.toJSON())
        .then((res) {
      final body = json.decode(res.body);
      newOrder.id = body["name"];
      _orders.insert(0, newOrder);
      notifyListeners();
    });
  }
}
