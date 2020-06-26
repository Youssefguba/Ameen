import 'package:ameencommon/models/comment.dart';
import 'package:flutter/material.dart';

class InheritedCommentModel extends InheritedWidget{
  final CommentModel commentModel;
  final Widget child;

  InheritedCommentModel({Key key, this.commentModel, this.child}) : super(key: key, child: child);

  static InheritedCommentModel of(BuildContext context ){
    // ignore: deprecated_member_use
    return(context.inheritFromWidgetOfExactType(InheritedCommentModel) as InheritedCommentModel);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }


}