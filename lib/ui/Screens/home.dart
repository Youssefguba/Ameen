import 'package:ameen/ui/Screens/contacts_list.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/Screens/search_page.dart';
import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';

class Home extends StatefulWidget {
  FirebaseUser currentUser;

  Home({Key key, this.currentUser}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  PageController pageController;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ContactList(),
          NewsFeed(currentUser: widget.currentUser,),
          UserProfile(profileId: widget.currentUser?.uid, currentUser: widget.currentUser,),
          SearchPage(profileId: widget.currentUser?.uid, currentUser: widget.currentUser,)
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.cGreen,
        unselectedItemColor: AppColors.cBlack,
        unselectedLabelStyle: TextStyle(color: AppColors.cBlack),
        currentIndex: pageIndex, //
        onTap: onTapPage,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon (
              AssetImage("assets/images/email.png"),
              size: 22,
            ),
            title: new Text(
              'الرسائل',
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon (
              AssetImage("assets/images/home.png"),
              size: 22,
            ),
            title: new Text(
              'الصفحة الرئيسية',
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon (
              AssetImage("assets/images/account.png"),
              size: 22,
            ),
            title: Text(
              'الصفحة الشخصية',
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 22),
            title: Text(
              'بحث',
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPageChanged(int pageIndex){ setState(() => this.pageIndex = pageIndex ); }

  void onTapPage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut);
  }
}
