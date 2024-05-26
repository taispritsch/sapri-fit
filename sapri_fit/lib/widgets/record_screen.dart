import 'package:flutter/material.dart';
import '../constants.dart';
import './CustomScaffold.dart';

class RecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: kBackgroundPageColor,
      currentIndex: 1, 
      onTap: (index) {

        print('Índice atual: $index');
      },
      body: Center(
        child: Text('Conteúdo da Tela 1'),
      ),
    );
  }
}
