import 'package:ameencommon/localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';

/// This Class to represent the Widget of Adding Post Rectangle beside the Profile Picture
/// of the user and *Redirect* him to Creating Post Screen..
///                           Y.G

class AddNewCommentWidget extends StatelessWidget {
  final String hintText = "أكتب تعليقا ...";
  final Color color = Colors.grey[300];
  String authorPhoto;
  AddNewCommentWidget({this.authorPhoto});

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
              padding: EdgeInsets.all(14),
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.cBackground,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black12)
              ),
              child: Text(
                AppLocalizations.of(context).writeAComment,
                style: TextStyle(fontFamily: 'Dubai', fontSize: 12, height: 1.0, color: Colors.black38),
              ),
            ),
          ),
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: 5),
//            child: CircleAvatar(
//              radius: 15,
//              backgroundImage: authorPhoto == null ? AssetImage(AppIcons.AnonymousPerson) : CachedNetworkImageProvider(authorPhoto),
//              backgroundColor: Colors.transparent,
//            ),
//          ),
        ],
      ),
    );
  }
}