import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/config.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final url = Uri.parse("${Config.serverUrl}/products.json");

  var _items = <Product>[];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> fetchProcuts() async {
    try {
      final response = await http.get(url);
      final body = json.decode(response.body) as Map<String, dynamic>;
      var _newItems = <Product>[];
      body.forEach((key, value) => _newItems.add(
            Product(
              id: key,
              title: value["title"],
              description: value["description"],
              price: value["price"],
              imageUrl: value["imageUrl"],
              isFavorite: value["isFavorite"],
            ),
          ));
      _items = _newItems;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(Product product) =>
      http.post(url, body: product.toJSON()).then((res) {
        final body = json.decode(res.body);
        product.id = body["name"];
        _items.add(product);
        notifyListeners();
      }).catchError((err) {
        print(err);
        throw err;
      });

  void updateProduct(Product editedProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == editedProduct.id);
    if (prodIndex >= 0) {
      _items[prodIndex] = editedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
