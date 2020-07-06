import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/localizations.dart';
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
      backgroundColor: AppColors.cGreen,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.cGreen,
        title: Row(
          children: <Widget>[
            Text(
              AppLocalizations.of(context).messages,
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
          child: StreamBuilder(
              stream: DbRefs.chatsListRef
                  .document(currentUser.uid)
                  .collection(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: ShimmerWidget());
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ChatListViewItem(
                            context: context,
                            document: snapshot.data.documents[index]);
                      });
                }
              }),
        ),
      ),
    );
  }
}
