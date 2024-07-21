import 'package:flutter/material.dart';
import 'product.dart';
import 'package:shoppingapp/components/database/db.dart';


class WishlistProvider with ChangeNotifier {
  Set<String> _wishlistProductIds = {};

  Set<String> get wishlistProductIds => _wishlistProductIds;

  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final dbHelper = DBHelper();
    List<Watch> products = await dbHelper.getWishlistItems();
    _wishlistProductIds = products.map((product) => product.id).toSet();
    notifyListeners();
  }

  void toggleWishlist(Watch product) async {
    final dbHelper = DBHelper();
    if (_wishlistProductIds.contains(product.id)) {
      await dbHelper.removeWishlistItem(product.id);
      _wishlistProductIds.remove(product.id);
    } else {
      await dbHelper.insertWishlistItem(product);
      _wishlistProductIds.add(product.id);
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }
}
