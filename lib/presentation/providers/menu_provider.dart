import 'package:flutter/material.dart';
import 'package:waiter_app/data/repositories/menu_repository_impl_hive.dart';

import '../../data/data_sources/local_menu_data_source.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/menu_item.dart';

class MenuProvider with ChangeNotifier {
  final repository = MenuRepositoryImplHive(dataSource: LocalMenuDataSource());

  List<CategoryEntity> _categories = [];
  List<MenuItemEntity> _allItems = [];
  String? _selectedCategoryId;
  bool _loading = false;

  List<CategoryEntity> get categories => _categories;
  List<MenuItemEntity> get items =>
      _allItems.where((e) => e.categoryId == _selectedCategoryId).toList();
  String? get selectedCategoryId => _selectedCategoryId;
  bool get loading => _loading;

  MenuProvider() {
    loadMenu();
  }

  Future<void> loadMenu() async {
    _loading = true;
    notifyListeners();
    _categories = await repository.loadCategories();
    _allItems = await repository.loadMenuItems();
    if (_categories.isNotEmpty) {
      _selectedCategoryId = _categories.first.id;
    }
    _loading = false;
    notifyListeners();
  }

  void selectCategory(String id) {
    _selectedCategoryId = id;
    notifyListeners();
  }
}
