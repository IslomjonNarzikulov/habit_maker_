
import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/theme_data/theme_data.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == lightMode){
      themeData= darkMode;
    }else{
      themeData = lightMode;
    }
  }
}