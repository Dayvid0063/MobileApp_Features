import 'dart:async';
import 'package:shoppingapp/models/watch_order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            totalAmount REAL,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE orderItems (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productName TEXT,
            watchModel TEXT, -- Added watchModel column
            quantity INTEGER,
            unitPrice REAL,
            totalPrice REAL,
            FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Adding the new column to the existing table if it doesn't exist
          await db.execute('ALTER TABLE orderItems ADD COLUMN watchModel TEXT');
        }
      },
    );
  }

  Future<int> insertOrder(WatchOrder order) async {
    final db = await database;
    int orderId = await db.insert('orders', order.toMap());

    for (var item in order.items) {
      item.orderId = orderId;
      await db.insert('orderItems', item.toMap());
    }

    return orderId;
  }

  Future<List<WatchOrder>> getOrders() async {
    final db = await database;

    final orderMaps = await db.query('orders');
    final List<WatchOrder> orders = [];

    for (var orderMap in orderMaps) {
      final orderId = orderMap['id'] as int;
      final itemMaps = await db
          .query('orderItems', where: 'orderId = ?', whereArgs: [orderId]);

      final items =
          itemMaps.map((itemMap) => WatchOrderItem.fromMap(itemMap)).toList();
      final order = WatchOrder.fromMap(orderMap, items);
      orders.add(order);
    }

    return orders;
  }
}
