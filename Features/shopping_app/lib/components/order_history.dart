import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/op.dart';
import 'package:shoppingapp/models/watch_order.dart';
import 'package:shoppingapp/models/product.dart';
import 'order_info.dart';
import 'productscreen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<WatchOrderProvider>(context);
    final activeOrders = orderProvider.activeOrders;
    final completedOrders = orderProvider.completedOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active orders'),
            Tab(text: 'Completed orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(activeOrders, 'No active orders'),
          _buildOrderList(completedOrders, 'No completed orders yet'),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<WatchOrder> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              emptyMessage,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsScreen(),
                  ),
                );
              },
              child: const Text('Discover products'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: order.items.isNotEmpty
                ? Image.network(
                    order.items[0].productImage,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.receipt_long, color: Colors.blue.shade900),
            title: Text(
              order.items.isNotEmpty
                  ? order.items[0].watchModel
                  : 'Order #${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (order.items.isNotEmpty && order.items[0].color != null)
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: order.items[0].color,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    const SizedBox(width: 5),
                    Text(
                      order.items.isNotEmpty
                          ? Watch.getColorLabel(
                              order.items[0].color ?? Colors.transparent)
                          : 'N/A',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    const Text("|"),
                    const SizedBox(width: 5),
                    Text(
                      'Size: ${order.items.isNotEmpty ? order.items[0].size : 'N/A'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('₦${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(order: order),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
