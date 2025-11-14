import 'menu_item.dart';

class OrderItem {
  final MenuItemEntity item;
  final int quantity;
  OrderItem({required this.item, required this.quantity});
}

class OrderEntity {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime timestamp;

  OrderEntity(
      {required this.id,
      required this.items,
      required this.total,
      required this.timestamp});
}
