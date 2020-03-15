import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.mail),
          title: new Text(
            'الرسائل',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text(
            'الصفحة الرئيسية',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text(
            'الصفحة الشخصية',
            style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
