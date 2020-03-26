import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/Screens/contacts_list.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {

  @override
  _BottomNavigationState createState() => _BottomNavigationState();

}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: cGreen,
      currentIndex: _currentIndex, //
      onTap: _onTabTapped,
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
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );

  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}
