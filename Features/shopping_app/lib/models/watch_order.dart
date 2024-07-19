class WatchOrder {
  int? id;
  String customerName;
  double totalAmount;
  DateTime date;
  List<WatchOrderItem> items;

  WatchOrder({
    this.id,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
    };
  }

  factory WatchOrder.fromMap(Map<String, dynamic> map, List<WatchOrderItem> items) {
    return WatchOrder(
      id: map['id'] as int?,
      customerName: map['customerName'] as String? ?? '',
      totalAmount: map['totalAmount'] as double? ?? 0.0,
      date: DateTime.parse(map['date'] as String? ?? DateTime.now().toIso8601String()),
      items: items,
    );
  }
}

class WatchOrderItem {
  int? id;
  int? orderId;
  String watchModel;
  int quantity;
  double unitPrice;
  double totalPrice;

  WatchOrderItem({
    this.id,
    this.orderId,
    required this.watchModel,
    required this.quantity,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'watchModel': watchModel,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory WatchOrderItem.fromMap(Map<String, dynamic> map) {
    return WatchOrderItem(
      id: map['id'],
      orderId: map['orderId'],
      watchModel: map['watchModel'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
    )..totalPrice = map['totalPrice'];
  }
}
