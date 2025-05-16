import 'package:flutter/material.dart';
import 'package:money_note_app/screens/splash_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MoneyNoteApp());
}

class MoneyNoteApp extends StatelessWidget {
  const MoneyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kPrimaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kSecondaryColor,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kSecondaryColor,
          selectedItemColor: kAccentColor,
          unselectedItemColor: kTextLightColor,
        ),
      ),
      home: const SplashScreen(), // Changed from HomeScreen to SplashScreen
    );
  }
}
