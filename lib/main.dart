import 'package:flutter/material.dart';
import 'package:news/homepage.dart';
import 'package:news/loadData.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primaryColor: Color(0xFF201C46),
        backgroundColor: Color(0xFF26264B),
        cardColor: Color(0xFF302E5E),
      ),
      home: HomePage(),
    );
  }
}
