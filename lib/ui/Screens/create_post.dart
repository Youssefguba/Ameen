import 'dart:io';

import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreatePost extends StatefulWidget {
  FirebaseUser currentUser;
  CreatePost({Key key, this.currentUser}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController _postBodyController = TextEditingController();

  String postId = Uuid().v4();
  String userId;
  String username;
  String profilePicture;

  bool isUploading = false;

  File _imageSelected;
  var imageUrl;
  ImagePicker picker = ImagePicker();
  GlobalKey _circleAvatar = GlobalKey();

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    usersRef.document(userId).get().then((user) {
      username = user.data['username'];
      profilePicture = user.data['profilePicture'];
    });

    _postBodyController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    isUploading = false;
    _postBodyController.clear();
    _postBodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Align(
            alignment: FractionalOffset.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  createPost(
                    userId: userId,
                    postId: postId,
                    username: username,
                    postBody: _postBodyController.text,
                    profilePicture: profilePicture,
                    postImage: imageUrl,
                  );

                  showToast(context, 'لقد تم نشر الدعاء الخاص بك 🤲',
                      AppColors.cBlack);
                  popPage(context);
                },
                child: Visibility(
                  visible: _postBodyController.text.isEmpty ? false : true,
                  child: Text(
                    AppLocalizations.of(context).shareADoaa,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      color: AppColors.cGreen,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: isUploading
          ? LinearProgressIndicator(
              backgroundColor: AppColors.cBackground,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen),
            )
          : SingleChildScrollView(
              child: Container(
                height: double.maxFinite,
                margin: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    // TextField of Post
                    TextField(
                      controller: _postBodyController,
                      maxLength: 220,
                      maxLines: 10,
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

                    //Image and Close Btn
                    Visibility(
                      visible: isImageUploading() != null || imageUrl != null
                          ? true
                          : false,
                      maintainSize:
                          isImageUploading() != null || imageUrl != null
                              ? true
                              : false,
                      maintainAnimation:
                          isImageUploading() != null || imageUrl != null
                              ? true
                              : false,
                      maintainState:
                          isImageUploading() != null || imageUrl != null
                              ? true
                              : false,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        height: 350,
                        child: Stack(children: [
                          previewImage(),
                          IconButton(
                            splashColor: Colors.black,
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: () => setState(() {
                              imageUrl = null;
                            }),
                          ),
                        ]),
                      ),
                    ),

                    // ImageChoose Button
                    Align(
                        alignment: FractionalOffset.bottomLeft,
                        widthFactor: double.maxFinite,
                        child: Container(
                          child: IconButton(
                            onPressed: () => getImageFromPhone(),
                            icon: Icon(Icons.image, color: AppColors.cGreen),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.black12, width: 0.5)),
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  Future getImageFromPhone() async {
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageSelected = File(pickedImage.path);
    });
    uploadPhoto(context, "Posts Picture", _imageSelected).then((photoUrl) {
      setState(() {
        imageUrl = photoUrl;
      });
    });
  }

  // Preview Selected Image either From Facebook or From Storage
  dynamic previewImage() {
    //Check if image uploading?
    if (isImageUploading() == null) {
      return Container(color: Colors.white);
    } else if (isImageUploading()) {
      return Container(child: RefreshProgress(), color: AppColors.cBackground);

      //Check if uploading canceled?
    } else if (isUploadingCanceled() == null) {
      return Container(color: Colors.white);
    } else if (isUploadingCanceled()) {
      return Container(color: Colors.white);
    }

    //Put Image if completed
    if (imageUrl != null) {
      return Image.network(imageUrl, fit: BoxFit.fill);
    } else {
      return Container(color: Colors.white);
    }
  }
}
