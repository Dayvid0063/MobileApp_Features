import 'package:flutter/material.dart';

class Watch {
  final String name;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String details;
  final String manufacturer;
  final double rating;
  final int reviewCount;
  final String id;
  final List<Color> availableColors;
  final List<int> availableSizes;
  final List<WatchCategory> categories;

  static Map<Color, String> colorLabels = {
    Colors.red: 'Red',
    Colors.blue: 'Blue',
    Colors.yellow: 'Yellow',
    Colors.green: 'Green',
    Colors.orange: 'Orange',
    Colors.purple: 'Purple',
    Colors.black: 'Black',
    Colors.white: 'White',
  };

  Watch({
    required this.name,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.details,
    required this.manufacturer,
    required this.rating,
    required this.reviewCount,
    required this.id,
    required this.availableColors,
    required this.availableSizes,
    required this.categories,
  });

  factory Watch.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      images = json['photos']
          .map<String>((photo) => 'https://api.timbu.cloud/images/${json['photos'][0]['url']}')
          .toList();
    } else {
      images = [
        'https://shj.org/wp-content/uploads/2018/04/no_product_image.jpg'
      ];
    }

    String details = json['description'] ?? '';
    String id = json['id'] ?? '';

    double price = 0.0;
    double? discountPrice;

    if (json['current_price'] != null && json['current_price'].isNotEmpty) {
      var prices = json['current_price'][0]['USD'];
      if (prices != null && prices.isNotEmpty) {
        price = prices[0]?.toDouble() ?? 0.0;
        if (prices.length > 1 && prices[1] != null) {
          discountPrice = prices[1]?.toDouble();
        }
      }
    }

    List<WatchCategory> categories = [];
    if (json['categories'] != null && json['categories'].isNotEmpty) {
      categories = (json['categories'] as List)
          .map((categoryJson) => WatchCategory.fromJson(categoryJson))
          .toList();
    }

    String manufacturer = '';
    if (categories.isNotEmpty) {
      manufacturer = capitalizeFirstLetter(categories[0].name);
    }

    List<Color> availableColors = [
      Colors.purple,
      Colors.orange,
      Colors.yellow,
      Colors.blue,
      Colors.red,
      Colors.black,
      Colors.white,
      Colors.green,
    ];

    List<int> availableSizes = [32, 35, 38, 39, 40, 42, 45];

    return Watch(
      name: json['name'],
      price: price,
      discountPrice: discountPrice,
      images: images,
      details: details,
      manufacturer: manufacturer,
      rating: 4.5,
      reviewCount: 32,
      id: id,
      availableColors: availableColors,
      availableSizes: availableSizes,
      categories: categories,
    );
  }

  static String getColorLabel(Color color) {
    final colorMap = {
      Colors.red: 'Red',
      Colors.blue: 'Blue',
      Colors.yellow: 'Yellow',
      Colors.green: 'Green',
      Colors.orange: 'Orange',
      Colors.purple: 'Purple',
      Colors.black: 'Black',
      Colors.white: 'White',
    };

    if (colorMap.containsKey(color)) {
      return colorMap[color]!;
    }

    final colorValue = color.value;
    for (var entry in colorMap.entries) {
      if (entry.key.value == colorValue) {
        return entry.value;
      }
    }

    return '';
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}

class WatchCategory {
  final String name;

  WatchCategory({required this.name});

  factory WatchCategory.fromJson(Map<String, dynamic> json) {
    return WatchCategory(name: json['name']);
  }
}
