import 'package:ameen/blocs/models/post.dart';
import 'package:flutter/material.dart';

class InheritedPostModel extends InheritedWidget{
  final PostData postModel;
  final Widget child;

  InheritedPostModel({
    Key key,
    @required this.postModel,
    this.child
}) : super(key: key, child: child);

  static InheritedPostModel of(BuildContext context ){
    return(context.inheritFromWidgetOfExactType(InheritedPostModel) as InheritedPostModel);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}