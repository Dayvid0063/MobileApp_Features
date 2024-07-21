import 'package:flutter/material.dart';
import 'product.dart';

class WatchCartModel extends ChangeNotifier {
  final List<WatchCartItem> _items = [];

  List<WatchCartItem> get items => _items;

  void addWristwatch(Watch wristwatch, int quantity, int size, Color? color) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.wristwatch == wristwatch && item.size == size && item.color == color,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(WatchCartItem(wristwatch, quantity, size, color));
    }
    notifyListeners();
  }

  void removeProduct(WatchCartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int getWristwatchQuantity(WatchCartItem item) {
    return item.quantity;
  }

  bool get isCartEmpty => _items.isEmpty;

  double get totalCartPrice {
    double total = 0.0;
    for (var item in _items) {
      total +=
          (item.wristwatch.discountPrice ?? item.wristwatch.price) * item.quantity;
    }
    return total;
  }
}

class WatchCartItem {
  final Watch wristwatch;
  int quantity;
  final int size;
  final Color? color;

  WatchCartItem(this.wristwatch, this.quantity, this.size, this.color);
}
