import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            quantity: existing.quantity + 1,
            price: existing.price),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(id: productId, title: title, quantity: 1, price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  int get itemCount => _items.length == 0
      ? 0
      : _items.entries
          .map((i) => i.value.quantity)
          .reduce((prev, curr) => prev + curr);

  double get totalAmount => _items.length == 0
      ? 0
      : _items.entries
          .map((i) => i.value.price)
          .reduce((prev, curr) => prev + curr);

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    var prod = _items[productId];
    if (prod != null && prod.quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                quantity: existingItem.quantity - 1,
                title: existingItem.title,
              ));
    } else
      _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
