import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter_app/presentation/screens/menu/widgets/bottom_cart_bar.dart';
import 'package:waiter_app/presentation/screens/menu/widgets/category_chips.dart';
import 'package:waiter_app/presentation/screens/menu/widgets/menu_list.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProv = Provider.of<MenuProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Menu'),
        elevation: 1,
      ),
      body: menuProv.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const CategoryChips(),
                Expanded(child: MenuList(items: menuProv.items)),
                const BottomCartBar(),
              ],
            ),
    );
  }
}
