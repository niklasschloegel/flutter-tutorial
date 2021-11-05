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
                })
            .toList(),
        "dateTime": dateTime.millisecondsSinceEpoch,
      });
}

class Orders with ChangeNotifier {
  final url = "${Config.serverUrl}/orders";

  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final newOrder = OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now());

    return http
        .post(Uri.parse("$url.json"), body: newOrder.toJSON())
        .then((res) {
      final body = json.decode(res.body);
      newOrder.id = body["name"];
      _orders.insert(0, newOrder);
      notifyListeners();
    });
  }
}
