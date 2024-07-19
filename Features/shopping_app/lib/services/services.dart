import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Apicall {
  final String baseUrl = 'https://api.timbu.cloud/products';
  final String organizationId = 'c9ad1fc74ad84acba6bce2fcc26a6e08';
  final String appId = '1QIK2YE6HUURBNH';
  final String apiKey = '495f4e76ebae469f8c55d39b5e45ff1820240708181732372546';

Future<Map<String, List<Watch>>> fetchProducts(int page, int size) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final items = jsonResponse['items'] as List;
      final products = items.map((item) => Watch.fromJson(item)).toList();

      List<Watch> featuredProducts = [];
      List<Watch> recommendedProducts = [];
      List<Watch> specialOfferProducts = [];

      for (var product in products) {
        if (product.details.contains('#Featured')) {
          featuredProducts.add(product);
        }
        if (product.details.contains('#Recommended')) {
          recommendedProducts.add(product);
        }
        if (product.details.contains('#SpecialOffer')) {
          specialOfferProducts.add(product);
        }
      }

      return {
        'featured': featuredProducts,
        'recommended': recommendedProducts,
        'specialOffer': specialOfferProducts,
      };
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Watch>> fetchProductsByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final items = jsonResponse['items'] as List;
      final products = items.map((item) => Watch.fromJson(item)).toList();

      return products
          .where((product) => product.categories.any((category) =>
              category.name.toLowerCase() == categoryName.toLowerCase()))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Watch>> fetchAllProducts(int page, int size) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey&page=$page&size=$size',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final items = jsonResponse['items'] as List;
      return items.map((item) => Watch.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
