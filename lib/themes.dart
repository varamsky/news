import 'package:flutter/material.dart';

bool isDark = false;

Color lightTextColor = Colors.black;
Color darkTextColor = Colors.white;

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  cardColor: Color(0xffEBEFF2),
  scaffoldBackgroundColor: Colors.white,
);


ThemeData darkTheme = ThemeData(
  primaryColor: Color(0xff201C46),
  backgroundColor: Color(0xff26264B),
  cardColor: Color(0xff302E5E),
);
