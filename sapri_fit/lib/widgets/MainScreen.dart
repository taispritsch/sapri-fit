import 'package:flutter/material.dart';
import 'package:sapri_fit/widgets/profile_screen.dart';
import 'package:sapri_fit/widgets/record_screen.dart';
import '../constants.dart';
import 'home_screen.dart';
import 'record_screen.dart';
import 'profile_screen.dart';
import './MyBottomNavigationBar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBodyForIndex(_currentIndex),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getBodyForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return RecordScreen();
      case 2:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }
}
