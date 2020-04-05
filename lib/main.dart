import 'package:flutter/material.dart';
import 'package:news/homepage.dart';
import 'package:news/themes.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: (isDark)?darkTheme:lightTheme,
      home: HomePage(),
    );
  }
}
