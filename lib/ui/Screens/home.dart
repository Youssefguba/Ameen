import 'package:ameen/ui/Screens/contacts_list.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 1;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 1,
    );
  }

  void onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTapPage(int pageIndex){
    pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ContactList(),
          NewsFeed(),
          UserProfile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.green[800],
        currentIndex: pageIndex, //
        onTap: onTapPage,
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
      ),
    );
  }
}
