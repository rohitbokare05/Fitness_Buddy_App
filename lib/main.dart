// ignore_for_file: unused_import
// import 'package:fitness_buddy_app/app.dart';
import 'package:fitness_buddy_app/buddy_finder_page.dart';
import 'package:fitness_buddy_app/group_organiser_page.dart';
import 'package:fitness_buddy_app/login_page.dart';
import 'package:fitness_buddy_app/on_board_buddy.dart';
import 'package:fitness_buddy_app/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 119, 226, 207)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Switches theme based on system setting
      home: SignupScreen(),
    );
  }
}
