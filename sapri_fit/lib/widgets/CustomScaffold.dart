import 'package:flutter/material.dart';
import '../constants.dart';
import './MyBottomNavigationBar.dart';

class CustomScaffold extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Widget body;
  final Color? backgroundColor;

  const CustomScaffold({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.body,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgorundColor,
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: body,
      backgroundColor: backgroundColor ?? Colors.white,
     
    );
  }
}
