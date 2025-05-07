import 'package:flutter/material.dart';
import 'modules/home/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cManager+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,      // AppBar matches background
          foregroundColor: Colors.black,      // Icon/text color in AppBar
          elevation: 0,                       // Flat AppBar look
          surfaceTintColor: Colors.transparent, // Prevent any overlay tint
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
