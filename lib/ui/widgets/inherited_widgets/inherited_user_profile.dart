import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:flutter/material.dart';


class InheritedUserProfile extends InheritedWidget{
  final UserModel userModel;
  final PostData postData;
  final Widget child;

  InheritedUserProfile({Key key, this.userModel, this.child, this.postData}) : super(key: key, child: child);

  static InheritedUserProfile of(BuildContext context ){
    return(context.inheritFromWidgetOfExactType(InheritedUserProfile) as InheritedUserProfile);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

}