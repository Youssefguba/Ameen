import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_user_profile.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatefulWidget {
  FirebaseUser currentUser;
  ProfileAppBar({Key key, @required this.currentUser}): super(key: key);

  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  UserModel user;
  String userId;
  final double appBarHeight = 80.0;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
  }
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return FutureBuilder(
      future: usersRef.document(userId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Container();
        }
        user = UserModel.fromDocSnapshot(snapshot.data);
        return Container(
          padding: new EdgeInsets.only(top: statusBarHeight),
          height: statusBarHeight + appBarHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage:  CachedNetworkImageProvider(user.profilePicture),
                ),
                Container(
                  child: Text(
                    user.username,
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
      },
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
