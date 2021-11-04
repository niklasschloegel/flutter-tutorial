import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
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
        "isFavorite": isFavorite,
      });

  void toggleFavorite() {
    this.isFavorite ^= true;
    notifyListeners();
  }

  @override
  String toString() =>
      "Product(title:$title, description: $description, price: $price, imageUrl: $imageUrl)";
}
