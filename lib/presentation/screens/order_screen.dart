import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/order.dart';
import '../providers/cart_provider.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: FutureBuilder<List<OrderEntity>>(
        future: Provider.of<CartProvider>(context, listen: false).loadOrders(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(
                child: Center(
              child: Text("No Orders yet",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ));
          }

          final orders = snap.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              final o = orders[i];

              return Dismissible(
                key: ValueKey(o.id),
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
                onDismissed: (_) async {
                  final removedOrder = o;
                  final cart =
                      Provider.of<CartProvider>(context, listen: false);

                  await cart.deleteOrder(o.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Order deleted"),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () async {
                          await cart.restoreOrder(removedOrder);
                          setState(() {});
                        },
                      ),
                    ),
                  );

                  setState(() {});
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    title: Text(
                      "Order (${o.items.length} items)",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Row(
                      children: [
                        const Text(
                          "Date: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat('dd-MM-yyyy').format(o.timestamp)),
                        const SizedBox(width: 16),
                        const Text(
                          "Time: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat('HH:mm').format(o.timestamp)),
                      ],
                    ),
                    trailing: Text("£${o.total}",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(order: o),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
