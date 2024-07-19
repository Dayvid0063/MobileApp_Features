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
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 16.0),
            const Text(
              'Order Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: order.items.map((item) => _buildOrderItem(item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order ID: ${order.id}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Customer: ${order.customerName}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOrderItem(WatchOrderItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 2.0,
      child: ListTile(
        leading: Image.network(
          item.watchModel,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image, size: 60);
          },
        ),
        title: Text(
          item.watchModel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}'),
        trailing: Text(
          '\$${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
