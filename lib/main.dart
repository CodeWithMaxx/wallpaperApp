import 'package:flutter/material.dart';
import 'package:wally/view/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WallyHomePage(),
    );
  }
}
