import 'package:flutter/material.dart';
import 'package:notesapp/themes/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData getThemeData() {
    return _themeData;
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool isDark() {
    if (_themeData == lightMode) {
      return false;
    } else {
      return true;
    }
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
