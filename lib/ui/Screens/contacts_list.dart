import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/widgets/chat_widgets/chat_list_view_item.dart';
import 'package:flutter/material.dart';

/*
* This class represent list of chats in messages section.
* Y.G
* */

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.cGreen,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: MyColors.cGreen,
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
