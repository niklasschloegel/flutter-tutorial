import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/config.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final url = "${Config.serverUrl}/products";
  var _items = <Product>[];

  late final String _authToken;
  late final String _userId;

  Products(this._items);

  set authToken(token) => _authToken = token;
  set userId(id) => _userId = id;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> fetchProcuts([bool filterByUser = false]) async {
    try {
      final filterUrl =
          filterByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : "";
      final response =
          await http.get(Uri.parse('$url.json?auth=$_authToken$filterUrl'));
      final body = json.decode(response.body) as Map<String, dynamic>?;
      if (body == null) return;

      final favoriteResponse = await http.get(Uri.parse(
          '${Config.serverUrl}/userFavorites/$_userId.json?auth=$_authToken'));
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?;

      var _newItems = <Product>[];

      body.forEach((id, data) => _newItems.add(
            Product(
              id: id,
              title: data["title"],
              description: data["description"],
              price: data["price"],
              imageUrl: data["imageUrl"],
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[id]?["isFavorite"] ?? false,
            ),
          ));
      _items = _newItems;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(Product product) => http
          .post(Uri.parse("$url.json?auth=$_authToken"),
              body: product.toJSON(_userId))
          .then((res) {
        final body = json.decode(res.body);
        product.id = body["name"];
        _items.add(product);
        notifyListeners();
      }).catchError((err) {
        print(err);
        throw err;
      });

  Future<void> updateProduct(Product editedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == editedProduct.id);
    if (prodIndex >= 0) {
      await http.patch(
          Uri.parse("$url/${editedProduct.id}.json?auth=$_authToken"),
          body: editedProduct.toJSON(_userId));
      _items[prodIndex] = editedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    return http.delete(Uri.parse("$url/$id.json?auth=$_authToken")).then((res) {
      if (res.statusCode >= 400)
        throw HttpException("Could not delete message");
    }).catchError((e) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw e;
    });
  }
}
