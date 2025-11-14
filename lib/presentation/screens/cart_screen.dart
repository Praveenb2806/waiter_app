import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: items.isEmpty
          ? const Center(
              child: Text("No Items in Cart",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      final it = items[i];

                      return Dismissible(
                        key: ValueKey(it.item.id),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          final removed = it;
                          cart.removeItemCompletely(it.item);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Item removed"),
                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () => cart.restoreItem(removed),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            title: Text(
                              it.item.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle:
                                Text("£${it.item.price} x ${it.quantity}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          cart.removeOne(it.item);
                                        },
                                        child:
                                            const Icon(Icons.remove, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        transitionBuilder: (child, anim) =>
                                            FadeTransition(
                                                opacity: anim, child: child),
                                        child: Text(
                                          "${it.quantity}",
                                          key: ValueKey(it.quantity),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () {
                                          cart.addItem(it.item);
                                        },
                                        child: const Icon(Icons.add, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, -2))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: £${cart.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () async {
                          await cart.placeOrder();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order Placed")),
                          );
                        },
                        child: const Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding:
            items.isEmpty ? EdgeInsets.zero : const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          child: const Icon(Icons.receipt_long),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            );
          },
        ),
      ),
    );
  }
}
