import 'package:flutter/material.dart';
import '../constants.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kInativeColor,
      backgroundColor: kBackgorundColor,
      onTap: onTap,
    );
  }
}
