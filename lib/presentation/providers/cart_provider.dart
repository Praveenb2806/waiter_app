import 'package:flutter/material.dart';
import '../../data/data_sources/local_menu_data_source.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/order.dart';
import '../../data/repositories/menu_repository_impl_hive.dart';

class CartProvider with ChangeNotifier {
  final Map<String, OrderItem> _items = {};
  final repo = MenuRepositoryImplHive(dataSource: LocalMenuDataSource());

  Map<String, OrderItem> get items => {..._items};

  int get itemCount => _items.length;

  double get total =>
      _items.values.fold(0.0, (sum, it) => sum + (it.item.price * it.quantity));

  /// Add item or increase quantity
  void addItem(MenuItemEntity item) {
    if (_items.containsKey(item.id)) {
      _items[item.id] =
          OrderItem(item: item, quantity: _items[item.id]!.quantity + 1);
    } else {
      _items[item.id] = OrderItem(item: item, quantity: 1);
    }
    notifyListeners();
  }

  /// Remove 1 quantity or fully delete
  void removeOne(MenuItemEntity item) {
    if (!_items.containsKey(item.id)) return;

    final current = _items[item.id]!;
    if (current.quantity > 1) {
      _items[item.id] =
          OrderItem(item: item, quantity: current.quantity - 1);
    } else {
      _items.remove(item.id);
    }
    notifyListeners();
  }

  /// Completely remove a cart item
  void removeItemCompletely(MenuItemEntity item) {
    _items.remove(item.id);
    notifyListeners();
  }

  /// Undo delete → restore full item including qty
  void restoreItem(OrderItem item) {
    _items[item.item.id] = item;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Save the order to Hive
  Future<void> placeOrder() async {
    if (_items.isEmpty) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final orderItems = _items.values.toList();

    final order = OrderEntity(
      id: id,
      items: orderItems,
      total: total,
      timestamp: DateTime.now(),
    );

    await repo.saveOrder(order);
    clear();
  }

  /// Load order list from Hive
  Future<List<OrderEntity>> loadOrders() async {
    return await repo.loadOrders();
  }

  /// DELETE order permanently from Hive
  Future<void> deleteOrder(String id) async {
    await repo.deleteOrder(id);
    notifyListeners();
  }

  /// Restore deleted order → used for UNDO
  Future<void> restoreOrder(OrderEntity order) async {
    await repo.saveOrder(order);
    notifyListeners();
  }
}
