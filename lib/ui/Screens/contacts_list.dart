import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/widgets/bottom_navigation.dart';
import 'package:ameen/ui/widgets/chat_widgets/chat_list_view_item.dart';
import 'package:flutter/material.dart';

/*
* This class represent list of chats in messages section.
*
* Y.G
* */

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cGreen,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: cGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "الرسائل",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.arrow_forward),
//            color: Colors.white,
//            disabledColor: Colors.white,
//            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => NewsFeed(),
//                ),
//              );
//            },
//          ),
//        ],
      ),
      body: Container(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: ListView(
              children: <Widget>[
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),
                ChatListViewItem(
                  hasUnreadMessage: true,
                  image: AssetImage('assets/images/person_test.png'),
                  lastMessage:
                  "السلام عليكم ورحمة الله وبركاته ",
                  name: "محمد أحمد ",
                  newMesssageCount: 8,
                  time: "19:27 PM",),

              ],
            ),
        ),
      ),
    );
  }
}
