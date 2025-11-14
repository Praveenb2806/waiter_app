import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';

class MenuList extends StatelessWidget {
  final List<MenuItemEntity> items;
  const MenuList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final item = items[i];
        return AnimatedOpacity(
          opacity: 1,
          duration: Duration(milliseconds: 250 + (i * 40)),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            shadowColor: Colors.black12,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.image,
                      width: 66,
                      height: 66,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('£${item.price}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => cartProv.addItem(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(68, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
