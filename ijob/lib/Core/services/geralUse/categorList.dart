import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/utils/urls.dart';

class Categorlist extends ChangeNotifier {
  final List<Categor> _categories = [];
  final String _categorUrl = Urls.categorUrl;

  List<Categor> get categories => [..._categories];

  int get categoryCount {
    return _categories.length;
  }

  Categor? categoryById(String id) {
    Categor? cat = _categories
        .where((cat) => cat.id == id)
        .toList()
        .singleOrNull;
    if (cat == null) {
      return null;
    } else {
      return cat;
    }
  }

  Future<void> loadCategors() async {
    _categories.clear();

    final response = await http.get(Uri.parse("$_categorUrl.json"));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((categoryId, categoryData) {
      _categories.add(
        Categor(
          id: categoryId,
          name: categoryData['name'],
          icon: categoryData['icon'],
        ),
      );
    });
    notifyListeners();
  }

  void addCategor(Categor category) {
    _categories.add(category);
  }
}
