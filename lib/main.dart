import 'package:flutter/material.dart';
import 'package:imgtopdf/createpdf.dart';
import 'package:imgtopdf/list_page.dart';
import 'package:imgtopdf/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        primaryColorDark: Colors.yellow,
      ),
      routes: {
        '/list_page': (context) => const List_Page(),
        '/create_page': (context) => const Create_pdf(),
      },
      home: const Main_Page(),
    );
  }
}
