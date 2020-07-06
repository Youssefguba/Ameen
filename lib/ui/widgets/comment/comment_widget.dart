import 'package:ameencommon/models/comment.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


//class CommentWidget extends StatefulWidget {
//   CommentModel commentModel;
//   String commentId, commentBody;
//   Timestamp createdAt;
//   String authorName, authorPhoto, authorId;
//
//   CommentWidget({Key key, this.commentModel,
//     this.commentId,
//     this.commentBody,
//     this.createdAt,
//     this.authorName,
//     this.authorId,
//     this.authorPhoto,});
//
//   factory CommentWidget.fromDocument(DocumentSnapshot doc) {
//     return CommentWidget(
//       authorName: doc['username'],
//       authorId: doc['userId'],
//       commentBody: doc['comment'],
//       createdAt: doc['created_at'],
//       authorPhoto: doc['authorPhoto'],
//     );
//   }
//
//  @override
//  _CommentWidgetState createState() => _CommentWidgetState();
//}

class CommentWidget extends StatelessWidget {
  CommentModel commentModel;
   String commentId, commentBody;
   Timestamp createdAt;
   String authorName, authorPhoto, authorId;

   CommentWidget({Key key, this.commentModel,
     this.commentId,
     this.commentBody,
     this.createdAt,
     this.authorName,
     this.authorId,
     this.authorPhoto,});

   factory CommentWidget.fromDocument(DocumentSnapshot doc) {
     return CommentWidget(
       authorName: doc['username'],
       authorId: doc['userId'],
       commentBody: doc['comment'],
       createdAt: doc['created_at'],
       authorPhoto: doc['authorPhoto'],
     );
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3, right: 3, top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // User Image
          Container(
            alignment: Alignment.topRight,
            child: CircleAvatar (
              backgroundImage: authorPhoto == null ? AssetImage('assets/images/icon_person.png') : CachedNetworkImageProvider(authorPhoto),
              radius: 20,
              backgroundColor: Colors.white,
            ),
          ),
          // User comment
          Expanded(
            child: Container(
              child: Bubble(
                margin: BubbleEdges.only(top: 10),
                color: Colors.white,
                stick:  false,
                radius: Radius.circular(20.0),
                elevation: 1.0,
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 10, top: 3),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        _headerOfComment(),
                        _bodyOfComment(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _headerOfComment() {
//    initializeDateFormatting('ar');

    var timestamp = createdAt.toDate();
    var date = DateFormat.yMMMd('ar').add_jm().format(timestamp);

    return Container(
      child: Column(
        children: <Widget>[
          // Name of Comment's User
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              authorName ?? '',
              style: TextStyle(
                  fontFamily: 'Dubai', fontSize: 14.0, color: Colors.black87),
            ),
          ),

          // Time of the Comment
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              timeago.format(timestamp, locale: 'ar'),
              style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 11.0,
                  color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyOfComment() {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Container(
        child: Text(
          commentBody,
          style: TextStyle(
              fontFamily: 'Dubai', fontSize: 14.0, color: Colors.black),
        ),
      ),
    );
  }
}
