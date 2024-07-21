import 'package:flutter/material.dart';
import 'package:shoppingapp/components/database/db.dart';
import 'watch_order.dart';

class WatchOrderProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<WatchOrder> _completedOrders = [];
  List<WatchOrder> _activeOrders = [];

  List<WatchOrder> get completedOrders => _completedOrders;
  List<WatchOrder> get activeOrders => _activeOrders;

  WatchOrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final allOrders = await _dbHelper.getOrders();
    _activeOrders = allOrders.where((order) => !order.isCompleted).toList();
    _completedOrders = allOrders.where((order) => order.isCompleted).toList();
    notifyListeners();
  }

  Future<void> addWatchOrder(WatchOrder order) async {
    await _dbHelper.insertOrder(order);
    await _loadOrders();
  }
}
