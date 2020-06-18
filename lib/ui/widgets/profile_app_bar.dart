import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_user_profile.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatefulWidget {
  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  final double appBarHeight = 80.0;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    UserModel userModel = InheritedUserProfile.of(context).userModel;

    return Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/icon_person.png',
              width: 100.0,
              height: 100.0,
            ),
            Container(
              child: Text(
                 userModel.username,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Dubai',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _followersAndFollowingRow(),
            _addDoaaButton(context),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addDoaaButton(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePost(),
          ),
        );
      },
      color: AppColors.green[900],
      padding: EdgeInsets.all(5),
      elevation: 1.0,
      hoverColor: Colors.white,
      textColor: Colors.white,
      disabledColor: AppColors.green,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
      animationDuration: Duration(seconds: 2),
      child: Text(
        "إضافة دعاء +",
        style:
            TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
      ),
    );
  }

  Widget _followersAndFollowingRow() {
//    UserModel userModel = InheritedUserProfile.of(context).userModel;
//    int totalOfFollowers = userModel.followers.length;

    return Container(
      padding: EdgeInsets.all(13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Flexible(
//
//            // Followers Text
//            child: Text(
//              "${totalOfFollwers} متابعين ",
//              textDirection: TextDirection.rtl,
//              style: TextStyle(
//                  fontSize: 14,
//                  color: Colors.black,
//                  fontFamily: 'Dubai',
//                  fontWeight: FontWeight.bold),
//            ),
//          ),

          // Following Text
//          Text(
//            "50 متابعاً      ",
//            textDirection: TextDirection.rtl,
//            style: TextStyle(
//                fontSize: 14,
//                color: Colors.black,
//                fontFamily: 'Dubai',
//                fontWeight: FontWeight.bold),
//          )
        ],
      ),
    );
  }
}
