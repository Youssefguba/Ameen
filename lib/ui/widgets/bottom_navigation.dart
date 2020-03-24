import 'package:ameen/helpers/ui/app_color.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;

  const BottomNavigation(this.currentIndex);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();

}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: cGreen,
      currentIndex: widget.currentIndex, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon (
              AssetImage("assets/images/email.png"),
              size: 24,
          ),
          title: new Text(
            'الرسائل',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon (
            AssetImage("assets/images/home.png"),
            size: 24,
          ),
          title: new Text(
            'الصفحة الرئيسية',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon (
            AssetImage("assets/images/account.png"),
            size: 24,
          ),
          title: Text(
            'الصفحة الشخصية',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );
  }
}
