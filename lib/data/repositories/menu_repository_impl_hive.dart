import 'package:hive/hive.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/menu_repository.dart';
import '../data_sources/local_menu_data_source.dart';

class MenuRepositoryImplHive implements MenuRepository {
  final LocalMenuDataSource dataSource;
  static const ordersBoxName = 'orders_box';

  MenuRepositoryImplHive({required this.dataSource});

  Future<Box> _box() async => await Hive.openBox(ordersBoxName);

  @override
  Future<List<CategoryEntity>> loadCategories() async {
    final model = await dataSource.loadMenuFromAssets();
    return model.categories;
  }

  @override
  Future<List<MenuItemEntity>> loadMenuItems() async {
    final model = await dataSource.loadMenuFromAssets();
    return model.items;
  }

  @override
  Future<void> saveOrder(OrderEntity order) async {
    final box = await _box();

    final map = {
      'id': order.id,
      'timestamp': order.timestamp.toIso8601String(),
      'total': order.total,
      'items': order.items.map((it) {
        return {
          'id': it.item.id,
          'name': it.item.name,
          'price': it.item.price,
          'quantity': it.quantity,
          'categoryId': it.item.categoryId,
          'image': it.item.image,
        };
      }).toList()
    };

    await box.add(map);
  }

  @override
  Future<List<OrderEntity>> loadOrders() async {
    final box = await _box();
    List<OrderEntity> list = [];

    for (var raw in box.values) {
      final items = (raw['items'] as List).map((e) {
        final menuItem = MenuItemEntity(
          id: e['id']?.toString() ?? "",
          categoryId: e['categoryId']?.toString() ?? "",
          name: e['name']?.toString() ?? "",
          image: e['image']?.toString() ?? "assets/images/default.png",
          price: (e['price'] as num?)?.toDouble() ?? 0.0,
        );
        return OrderItem(
          item: menuItem,
          quantity: e['quantity'] ?? 1,
        );
      }).toList();

      list.add(
        OrderEntity(
          id: raw['id']?.toString() ?? "",
          items: items,
          total: (raw['total'] as num?)?.toDouble() ?? 0.0,
          timestamp:
              DateTime.tryParse(raw['timestamp'] ?? "") ?? DateTime.now(),
        ),
      );
    }

    return list.reversed.toList();
  }

  Future<void> deleteOrder(String id) async {
    final box = await _box();
    final keys = box.keys.toList();

    for (var key in keys) {
      final raw = box.get(key);
      if (raw['id'] == id) {
        await box.delete(key);
        break;
      }
    }
  }
}
