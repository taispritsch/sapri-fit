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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 2.0,
          color: Colors.grey,
        ),
        BottomAppBar(
          color: kBackgorundColor,
          child: SizedBox(
            height: 70.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.home, color: currentIndex == 0 ? kPrimaryColor : kInativeColor),
                  onPressed: () => onTap(0),
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.add, color: currentIndex == 1 ? kPrimaryColor : kInativeColor),
                  onPressed: () => onTap(1),
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.person, color: currentIndex == 2 ? kPrimaryColor : kInativeColor),
                  onPressed: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
