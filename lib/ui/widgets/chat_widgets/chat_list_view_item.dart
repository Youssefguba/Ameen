import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/chat_page.dart';
import 'package:flutter/material.dart';

/*
* This class represent the Design of one chat item
*
* Y.G
*  */
class ChatListViewItem extends StatelessWidget {
  final AssetImage image;
  final String name;
  final String lastMessage;
  final String time;
  final bool hasUnreadMessage;
  final int newMesssageCount;

  const ChatListViewItem(
      {Key key,
      this.image,
      this.name,
      this.lastMessage,
      this.time,
      this.hasUnreadMessage,
      this.newMesssageCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: image,
                    radius: 30,
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(name,
                      style: TextStyle(
                          fontFamily: 'Dubai', fontWeight: FontWeight.bold)),
                  subtitle: Text(lastMessage,
                      maxLines: 1, style: TextStyle(fontFamily: 'Dubai')),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                      hasUnreadMessage
                          ? Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: AppColors.cGreen,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  )),
                              child: Center(
                                  child: Text(
                                newMesssageCount.toString(),
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              )),
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Divider(
            endIndent: 12.0,
            indent: 12.0,
            height: 0,
          ),
        ],
      ),
    );
  }
}
