import 'package:flutter/material.dart';

//baseado no iconMapper

class Icnomap {
  static final Map<String, IconData> _iconMap = {
    //custom
    "format_paint": Icons.format_paint,
    "power": Icons.power,
    "bathroom": Icons.bathroom,
    "water_drop_outlined": Icons.water_drop_outlined,
    "menu_book": Icons.menu_book,
    "fire_truck_sharp": Icons.fire_truck_sharp,
    "construction": Icons.construction,
    "default": Icons.question_mark,
  };

  static IconData getIconData(String iconName) {
    final normalizedKey = iconName.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return _iconMap[normalizedKey] ?? Icons.circle;
  }
}
