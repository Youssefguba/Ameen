import 'package:ameencommon/localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:uuid/uuid.dart';

class CreatePost extends StatefulWidget {
  FirebaseUser currentUser;
  CreatePost({Key key, this.currentUser}): super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  CollectionReference _postsRef  = Firestore.instance.collection(DatabaseTable.posts);
  CollectionReference _usersRef  = Firestore.instance.collection(DatabaseTable.users);
  TextEditingController _postBodyController = TextEditingController();

  String postId = Uuid().v4();
  String userId;
  String username;
  String profilePicture;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    _usersRef.document(userId).get().then((user) {
      username = user.data['username'];
      profilePicture = user.data['profilePicture'];
    });

    _postBodyController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    isUploading = false;
    _postBodyController.dispose();
    _postBodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).writeADoaa,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: ImageIcon(
                AssetImage("assets/images/arrow_back.png"),
                size: 18,
                color: Colors.black,
              ),
            ),
      ),
      body: isUploading ? LinearProgressIndicator (
        backgroundColor: AppColors.cBackground,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen),
      )
          :  Container (
        height: double.maxFinite,
        margin: EdgeInsets.all(15),
        child: Column (
          children: <Widget> [

            // TextField of Post
            TextField(
              controller: _postBodyController,
              maxLength: 220,
              maxLines: 9,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              showCursor: true,
              maxLengthEnforced: false,
              expands: false,
              minLines: 1,
              scrollController: ScrollController(),
              scrollPhysics: BouncingScrollPhysics(),
              cursorColor: AppColors.green[900],
              style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
                hintText: AppLocalizations.of(context).postADoaaYouWant,
                hintStyle: TextStyle(
                  fontFamily: 'Dubai',
                ),
              ),
            ),
            // Post Button
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                widthFactor: double.maxFinite,
                child: Visibility(
                  visible: _postBodyController.text.isEmpty ? false : true,
                  child: FlatButton(
                    focusColor: AppColors.cBackground,
                    hoverColor: AppColors.cBackground,
                    onPressed: () {
                      createPost(_postsRef, userId, DatabaseTable.userPosts, postId, username, _postBodyController.text, profilePicture);
                      showToast(context, 'لقد تم نشر الدعاء الخاص بك 🤲🏻', AppColors.cBlack);
                      popPage(context);
                    } ,
                    padding: EdgeInsets.symmetric(vertical: 13,horizontal: 5),
                    color: _postBodyController.text.isEmpty ? AppColors.cBackground : AppColors.cGreen,
                    disabledColor:  _postBodyController.text.isEmpty ? AppColors.cBackground : AppColors.cGreen,
                    child: Text(
                      AppLocalizations.of(context).shareADoaa,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Dubai',
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}