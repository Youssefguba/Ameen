import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/models/post_details.dart';
import 'package:flutter/material.dart';

class InheritedPostModel extends InheritedWidget{
  final PostData postData;
  final PostDetails postDetails;
  final Widget child;

  InheritedPostModel({
    Key key,
    this.postData,
    this.postDetails,
    this.child
}) : super(key: key, child: child);

  static InheritedPostModel of(BuildContext context ){
    // ignore: deprecated_member_use
    return(context.inheritFromWidgetOfExactType(InheritedPostModel) as InheritedPostModel);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}