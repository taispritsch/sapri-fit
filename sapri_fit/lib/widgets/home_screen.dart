import 'package:flutter/material.dart';
import '../constants.dart';
import './CustomScaffold.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: kBackgroundPageColor,
      currentIndex: 0,
      onTap: (index) {
        print('Índice atual: $index');
      },
      body: Center(
        child: Text('Bem-vindo à tela inicial!'),
      ),
    );
  }
}
