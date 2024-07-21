import 'package:flutter/material.dart';

class WatchOrder {
  int? id;
  String customerName;
  double totalAmount;
  DateTime date;
  final bool isCompleted;
  List<WatchOrderItem> items;

  WatchOrder({
    this.id,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory WatchOrder.fromMap(Map<String, dynamic> map, List<WatchOrderItem> items) {
    return WatchOrder(
      id: map['id'] as int?,
      customerName: map['customerName'] as String? ?? '',
      totalAmount: map['totalAmount'] as double? ?? 0.0,
      date: DateTime.parse(map['date'] as String? ?? DateTime.now().toIso8601String()),
      items: items,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class WatchOrderItem {
  int? id;
  int? orderId;
  String watchModel;
  String productImage;
  int quantity;
  double unitPrice;
  double totalPrice;
  Color? color;
  String? size;


  WatchOrderItem({
    this.id,
    this.orderId,
    required this.watchModel,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    this.color,
    this.size,
  }) : totalPrice = quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'watchModel': watchModel,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'color': color?.value,
      'size': size,
    };
  }

  factory WatchOrderItem.fromMap(Map<String, dynamic> map) {
    return WatchOrderItem(
      id: map['id'] as int?,
      orderId: map['orderId'] as int?,
      watchModel: map['watchModel'] as String? ?? '',
      productImage: map['productImage'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      unitPrice: map['unitPrice'] as double? ?? 0.0,
      color: map['color'] != null ? Color(map['color']) : null,
      size: map['size'] as String?,
    )..totalPrice = (map['totalPrice'] as double? ?? 0.0);
  }
}
