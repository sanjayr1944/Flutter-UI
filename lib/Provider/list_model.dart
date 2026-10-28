import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {
  //Value
  List<int> countValue = [1, 2, 3, 4, 5];
  //Funcation

  void add() {
    int last = countValue.last;
    countValue.add(last + 1);
    notifyListeners();
  }

  //Must Listners - notifyLisntners
}
