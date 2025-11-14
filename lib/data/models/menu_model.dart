import '../../domain/entities/category.dart';
import '../../domain/entities/menu_item.dart';

class MenuModel {
  final List<CategoryEntity> categories;
  final List<MenuItemEntity> items;

  MenuModel({required this.categories, required this.items});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    final cats = (json['categories'] as List)
        .map((e) => CategoryEntity(id: e['id'], name: e['name']))
        .toList();
    final items = (json['items'] as List)
        .map((e) => MenuItemEntity(
              id: e['id'],
              categoryId: e['categoryId'],
              name: e['name'],
              image: e['image'] ?? "assets/images/burger.png",
              price: (e['price'] as num).toDouble(),
            ))
        .toList();
    return MenuModel(categories: cats, items: items);
  }
}
