import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  ThemeProvider(){
    getDarkThemeData();
  }
   bool _isDark= false;
 static const String THEME_DATA = 'ThemeData';
 bool get getDarkTheme => _isDark;

 Future<void> setDarkTheme({required bool setDart})async{
   SharedPreferences prefs=await SharedPreferences.getInstance();
   prefs.setBool(THEME_DATA,setDart );
   _isDark = setDart;
   notifyListeners();
 }

 Future<void>  getDarkThemeData()async{
   SharedPreferences prefs=await SharedPreferences.getInstance();
   _isDark = prefs.getBool(THEME_DATA)!;
   notifyListeners();


 }
}