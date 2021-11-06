import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import '../config.dart';

class Product with ChangeNotifier {
  final url = "${Config.serverUrl}";

  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  String toJSON() => json.encode({
        "title": title,
        "description": description,
        "price": price,
        "imageUrl": imageUrl,
      });

  Future<void> toggleFavorite(String token, String userId) {
    this.isFavorite ^= true;
    notifyListeners();
    return http
        .put(Uri.parse("$url/userFavorites/$userId/$id.json?auth=$token"),
            body: json.encode({"isFavorite": isFavorite}))
        .then((res) => {
              if (res.statusCode >= 400)
                throw HttpException("Favorite status could not be updated")
            })
        .catchError((e) {
      this.isFavorite ^= true;
      notifyListeners();
      throw e;
    });
  }

  @override
  String toString() =>
      "Product(title:$title, description: $description, price: $price, imageUrl: $imageUrl)";
}
