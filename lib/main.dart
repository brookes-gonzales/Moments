import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MomentApp());
}

class MomentApp extends StatelessWidget {
  const MomentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
      ),
      home: const HomeScreen(),
    );
  }
}