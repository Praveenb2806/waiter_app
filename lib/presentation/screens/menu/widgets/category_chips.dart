import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/menu_provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProv = Provider.of<MenuProvider>(context);
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemBuilder: (ctx, i) {
          final c = menuProv.categories[i];
          final selected = c.id == menuProv.selectedCategoryId;
          return GestureDetector(
            onTap: () => menuProv.selectCategory(c.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: selected
                    ? [
                        const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ]
                    : [],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                c.name,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: menuProv.categories.length,
      ),
    );
  }
}
