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

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    _usersRef.document(userId).get().then((user) => username = user.data['username']);

    _postBodyController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    setState(() => isUploading = false);
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
          "أكتب دعاء ",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ImageIcon(
              AssetImage("assets/images/back.png"),
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
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
              textAlign: TextAlign.right,
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
                hintText: " ... أكتب الدعاء الذي يجول بخاطرك ",
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
                      createPost(_postsRef, userId, DatabaseTable.userPosts, postId, username, _postBodyController.text);
                      showToast(context, 'لقد تم نشر الدعاء الخاص بك 🤲🏻', AppColors.cBlack);
                      popPage(context);
                    } ,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: _postBodyController.text.isEmpty ? AppColors.cBackground : AppColors.cGreen,
                    disabledColor:  _postBodyController.text.isEmpty ? AppColors.cBackground : AppColors.cGreen,
                    child: Text(
                      "نشر الدعاء",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Dubai',
                        color: Colors.white,
                        fontSize: 19,
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