import '../entities/category.dart';
import '../entities/menu_item.dart';
import '../entities/order.dart';


abstract class MenuRepository {
  Future<List<CategoryEntity>> loadCategories();
  Future<List<MenuItemEntity>> loadMenuItems();
  Future<void> saveOrder(OrderEntity order);
  Future<List<OrderEntity>> loadOrders();
}