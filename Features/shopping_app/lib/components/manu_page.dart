import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/components/pc.dart';
import 'package:shoppingapp/models/product.dart';
import 'package:shoppingapp/services/services.dart';
import 'package:shoppingapp/models/wp.dart';

class BrandProductsPage extends StatelessWidget {
  final String brandName;

  const BrandProductsPage({required this.brandName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brandName),
      ),
      body: FutureBuilder<List<Watch>>(
        future: Apicall().fetchProductsByCategory(brandName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ChangeNotifierProvider.value(
                  value: Provider.of<WishlistProvider>(context),
                  child: ProductCard(product: product),
                );
              },
            );
          }
        },
      ),
    );
  }
}
