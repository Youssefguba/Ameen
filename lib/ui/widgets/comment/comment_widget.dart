import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:intl/date_symbol_data_local.dart';

class CommentWidget extends StatelessWidget {
   CommentModel commentModel;
   CommentWidget({Key key, this.commentModel});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ar');

    return InheritedCommentModel(
      commentModel: commentModel,
      child: Container(
        margin: EdgeInsets.only(left: 3, right: 3, top: 8, bottom: 8),
        color: myColors.cBackground,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // User Image
            // TODO => Put here the Image of User Account.
            Container (
                child: Image.asset(
                'assets/images/icon_person.png',
                 width: 45,
                 height: 45,
                 alignment: Alignment.topRight,
                 fit: BoxFit.contain,
            )),

            // User comment
            Expanded(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(23),
                      bottomRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10, top: 3),
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(color: Colors.white),
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
      ),
    );
  }

  Widget _headerOfComment() {

    initializeDateFormatting('ar');

    return Container(
      child: Column(
        children: <Widget>[
          // Name of Comment's User
          Container(
            alignment: Alignment.topRight,
            child: Text(
              commentModel.authorName,
              style: TextStyle(
                  fontFamily: 'Dubai', fontSize: 14.0, color: Colors.black87),
            ),
          ),

          // Time of the Comment
          Container(
            alignment: Alignment.topRight,
            child: Text(
              commentModel.postTimeFormatted,
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
          commentModel.commentBody,
          style: TextStyle(
              fontFamily: 'Dubai', fontSize: 14.0, color: Colors.black),
        ),
      ),
    );
  }
}
