import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/chat_page.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* This class represent the Design of one chat item
*
* Y.G
*  */
class ChatListViewItem extends StatelessWidget {
  final BuildContext context;
  final DocumentSnapshot document;

  const ChatListViewItem(
      {Key key, this.context, this.document}) : super(key: key);

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
                    backgroundImage: document['profilePicture'] == null
                        ? AssetImage(AppImages.AnonymousPerson)
                        : CachedNetworkImageProvider(document['profilePicture']),
                    radius: 23,
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(document['username'],
                      style: TextStyle(
                          fontFamily: 'Dubai', fontWeight: FontWeight.bold)),
                  subtitle: Text(document['lastMessage'],
                      maxLines: 1, style: TextStyle(fontFamily: 'Dubai')),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '12:00',
                        style: TextStyle(fontSize: 12),
                      ),
//                      hasUnreadMessage
//                          ? Container(
//                              margin: const EdgeInsets.only(top: 5.0),
//                              height: 20,
//                              width: 20,
//                              decoration: BoxDecoration(
//                                  color: AppColors.cGreen,
//                                  borderRadius: BorderRadius.all(
//                                    Radius.circular(25.0),
//                                  )),
//                              child: Center(
//                                  child: Text(
//                                newMesssageCount.toString(),
//                                style: TextStyle(
//                                    fontSize: 11, color: Colors.white),
//                              )),
//                            )
//                          : SizedBox(),
                    ],
                  ),
                  onTap: () { pushPage(context, ChatScreen(peerId: document['peerId'], peerAvatar: document['profilePicture'])); },
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
