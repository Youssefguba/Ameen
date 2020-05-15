import 'package:flutter/material.dart';

/// This Class to represent the Widget of Adding Post Rectangle beside the Profile Picture
/// of the user and *Redirect* him to Creating Post Screen..
///                           Y.G

class AddNewCommentWidget extends StatelessWidget {
  final String hintText = "أكتب تعليقا ...";
  final Color color = Colors.grey[300];

  final imageOfUser = 'assets/images/person_test.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      /// Row Contains Image of User and Container of Comment
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child:Container(
              padding: EdgeInsets.all(18),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black12)
              ),
              child: Text(
                hintText,
                style: TextStyle(fontFamily: 'Dubai', fontSize: 12, height: 1.0, color: Colors.black38),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,

              ),
            ),
          ),
          Container(
            width: 55,
            height: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage(imageOfUser),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}