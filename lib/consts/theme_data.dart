import 'package:flutter/material.dart';

import 'app_color.dart';


class style{
 static ThemeData themeData({required bool isDark}){
    return ThemeData(
      scaffoldBackgroundColor: isDark?AppColor.darkScaffoldColor: AppColor.lightScaffoldColor,
      //cardColor: ,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}