import 'package:flutter/material.dart';
import 'package:shoppingapp/components/database/db.dart';
import 'watch_order.dart';

class WatchOrderProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<WatchOrder> _completedOrders = [];

  List<WatchOrder> get completedOrders => _completedOrders;

  WatchOrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _completedOrders = await _dbHelper.getOrders();
    notifyListeners();
  }

  Future<void> addWatchOrder(WatchOrder order) async {
    await _dbHelper.insertOrder(order);
    await _loadOrders();
  }
}
