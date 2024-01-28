import 'package:flutter/material.dart';
import 'package:u_and_i/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w700,
              fontFamily: 'parisienne'),
          displayMedium: TextStyle(
              color: Colors.white, fontSize: 50, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      title: 'Material App',
      home: const HomeScreen(),
    );
  }
}
