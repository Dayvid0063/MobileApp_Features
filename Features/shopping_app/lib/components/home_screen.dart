import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'order_history.dart';
import 'productscreen.dart';
import 'package:shoppingapp/services/services.dart';
import '../models/product.dart';
import 'product_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, List<Watch>>> futureProducts;
  // ignore: unused_field
  int _currentCarouselIndex = 0;
  Set<String> wishlistedProductIds = {};

  @override
  void initState() {
    super.initState();
    futureProducts = Apicall().fetchProducts(1, 10);
  }

  void toggleWishlist(String productId) {
    setState(() {
      if (wishlistedProductIds.contains(productId)) {
        wishlistedProductIds.remove(productId);
      } else {
        wishlistedProductIds.add(productId);
      }
    });
  }

  void navigateToProductDetails(Watch product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product)),
    );
  }

  void showAllBrands(BuildContext context, Map<String, String> brandImages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Brands'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: brandImages.keys.map((brandName) {
                return _buildBrandIcon(brandName, brandImages);
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchMart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              FutureBuilder<Map<String, List<Watch>>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No products found'));
                  } else {
                    final products = snapshot.data!;
                    final brandImages = {
                      'Rolex': 'assets/images/watch6.jpg',
                      'Omega': 'assets/images/watch7.jpg',
                      'Tag Heuer': 'assets/images/watch8.jpeg',
                      'Patek Philippe': 'assets/images/watch9.jpeg',
                      'Casio': 'assets/images/watch10.jpeg',
                      'Seiko': 'assets/images/watch11.jpg',
                      'Hublot': 'assets/images/watch12.jpeg',
                      'Tudor': 'assets/images/watch13.jpg',
                      'Cartier': 'assets/images/watch14.jpg',
                      'Breitling': 'assets/images/watch1.webp'
                    };
                    final displayedBrands = brandImages.keys.take(9).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCarousel(products['recommended']!),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: [
                            ...displayedBrands.map((brandName) {
                              return _buildBrandIcon(brandName, brandImages);
                            }),
                            GestureDetector(
                              onTap: () {
                                showAllBrands(context, brandImages);
                              },
                              child: const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Text('All'),
                                  ),
                                  SizedBox(height: 5),
                                  Text('View All'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Our Special Offers'),
                        _buildProductList(products['specialOffer']!),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Featured Watches'),
                        _buildProductList(products['featured']!),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductsScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View more'),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
              'https://cdn3.iconfinder.com/data/icons/avatars-flat/33/man_5-512.png'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good afternoon 👋', style: TextStyle(fontSize: 16)),
            Text('David Orji',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandIcon(String brandName, Map<String, String> brandImages) {
    Widget brandIcon;

    if (brandImages.containsKey(brandName)) {
      brandIcon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipOval(
          child: Image.asset(
            brandImages[brandName]!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      brandIcon = CircleAvatar(
        radius: 30,
        child: Text(brandName[0]),
      );
    }

    return Column(
      children: [
        brandIcon,
        const SizedBox(height: 5),
        Text(brandName),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProductList(List<Watch> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2 / 3,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Watch product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToProductDetails(product);
                  },
                  child: Image.network(
                    product.images[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/nmi.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      wishlistedProductIds.contains(product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: wishlistedProductIds.contains(product.id)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleWishlist(product.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.manufacturer, style: const TextStyle(fontSize: 12)),
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Watch> products) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselIndex = index;
          });
        },
      ),
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                navigateToProductDetails(product);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(product.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
