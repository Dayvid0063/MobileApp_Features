import 'package:flutter/material.dart';
import 'package:shoppingapp/models/watch_order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final WatchOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            Text('Customer: ${order.customerName}'),
            Text('Total Amount: \$${order.totalAmount}'),
            const SizedBox(height: 16.0),
            const Text('Items:'),
            ...order.items.map((item) => ListTile(
                  leading:
                      Image.network(item.productImage, width: 50, height: 50),
                  title: Text(item.watchModel),
                  subtitle: Text('${item.quantity} x \$${item.unitPrice}'),
                  trailing: Text('\$${item.totalPrice}'),
                )),
          ],
        ),
      ),
    );
  }
}
