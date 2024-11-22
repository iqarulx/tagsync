import 'package:flutter/material.dart';
import 'package:tagsync/screens/reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xff45b0b2)),
      home: const Reader(),
    );
  }
}
