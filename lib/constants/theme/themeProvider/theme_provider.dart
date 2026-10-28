import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier
{
  ThemeMode themeMode = ThemeMode.light;

  ThemeMode get currentTheme => themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;


  void toggleTheme()
  {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setTheme(ThemeMode theme)
  {
    if(themeMode == theme) return;
    themeMode = theme;
    notifyListeners();
  }
}