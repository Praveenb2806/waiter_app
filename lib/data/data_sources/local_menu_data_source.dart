import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/menu_model.dart';

class LocalMenuDataSource {
  Future<MenuModel> loadMenuFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/menu.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return MenuModel.fromJson(jsonMap);
  }
}
