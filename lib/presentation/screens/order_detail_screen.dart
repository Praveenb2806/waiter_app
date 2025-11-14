import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: order.items.length,
              itemBuilder: (ctx, i) {
                final it = order.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(it.item.name,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                    subtitle: Text('Qty: ${it.quantity}'),
                    trailing: Text(
                        '\u00A3${(it.item.price * it.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: \u00A3${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                    'Placed on: ${DateFormat('dd-MM-yyyy HH:mm').format(order.timestamp)}'),
                const SizedBox(height: 12),
                const Text('My Previous Orders',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
