import 'package:flutter/material.dart';
import 'package:ijob/Data/dummyData.dart';
import 'package:ijob/Entities/categor.dart';

class Categorlist extends ChangeNotifier {
  List<Categor> _categories = DummyCategor;

  List<Categor> get categories => [..._categories];
}
