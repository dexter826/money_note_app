import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'input_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const InputScreen(), const CalendarScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: kSecondaryColor,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kTextLightColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Nhập vào'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
        ],
      ),
    );
  }
}
