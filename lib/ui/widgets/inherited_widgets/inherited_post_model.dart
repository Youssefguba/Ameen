import 'package:ameen/blocs/models/post_data.dart';
import 'package:flutter/material.dart';

class InheritedPostModel extends InheritedWidget{
  final PostData postData;
  final Widget child;

  InheritedPostModel({
    Key key,
    @required this.postData,
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