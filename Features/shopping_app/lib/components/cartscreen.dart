import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/cart.dart';
import 'package:shoppingapp/models/product.dart';
import 'checkoutscreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<WatchCartModel>(context);

    double totalCost = cart.totalCartPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        titleTextStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      body: cart.isCartEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      cartItem.wristwatch.images[0],
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.wristwatch.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (cartItem.color != null)
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: cartItem.color,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(width: 5),
                                              Text(
                                                Watch.getColorLabel(
                                                    cartItem.color ??
                                                        Colors.transparent),
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(width: 5),
                                              const Text("|"),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Size: ${cartItem.size}',
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      iconSize: 16,
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () {
                                                        cart.removeProduct(
                                                            cartItem);
                                                      },
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 30,
                                                      width: 30,
                                                      color:
                                                          Colors.blue.shade100,
                                                      child: Text(
                                                        '${cart.getWristwatchQuantity(cartItem)}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      iconSize: 16,
                                                      icon:
                                                          const Icon(Icons.add),
                                                      onPressed: () {
                                                        cart.addWristwatch(
                                                          cartItem.wristwatch,
                                                          1,
                                                          cartItem.size,
                                                          cartItem.color,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '₦${(cartItem.wristwatch.discountPrice != null ? cartItem.wristwatch.discountPrice! : cartItem.wristwatch.price) * cart.getWristwatchQuantity(cartItem)}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5.5,
                              right: 5.5,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                                onPressed: () {
                                  cart.removeProduct(cartItem);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total price: ₦${totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
