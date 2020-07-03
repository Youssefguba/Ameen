import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// This Class to represent the Widget of Adding comment Rectangle beside the Profile Picture
/// of the user and *Redirect* him to Post Page..
///                           Y.G

class AddNewPostWidget extends StatefulWidget {
  FirebaseUser currentUser;
  AddNewPostWidget({Key key, this.currentUser}) : super(key: key);

  @override
  _AddNewPostWidgetState createState() => _AddNewPostWidgetState();
}

class _AddNewPostWidgetState extends State<AddNewPostWidget> {
  CollectionReference usersRef =
      Firestore.instance.collection(DatabaseTable.users);
  UserModel user;
  dynamic userData;
  dynamic userPhoto;

  @override
  void initState() {
    _getUserData();
  }

  // Get user data
  _getUserData() {
    userData = getCurrentUserData(userId: widget.currentUser.uid);
    userData.then((doc) => setState(() {
          user = UserModel.fromDocument(doc);
          userPhoto = user.profilePicture;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // When Tapped on Container Redirect User to Creating Post Screen to Write post
          pushPage(context, CreatePost(currentUser: widget.currentUser));
        },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1.0),
              blurRadius: 1.0, // has the effect of softening the shadow
              offset: new Offset(1.0, 1.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(18),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.cBackground,
                    borderRadius:  BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black12)),
                child: Text(
                  AppTexts.hintText,
                  style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 12,
                      height: 1.0,
                      color: Colors.black38),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: userPhoto == null
                    ? AssetImage(AppImages.AnonymousPerson)
                    : CachedNetworkImageProvider(userPhoto),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
