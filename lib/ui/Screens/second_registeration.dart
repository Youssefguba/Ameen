import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ameen/blocs/global/global.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SecondRegisteration extends StatefulWidget {
  final FirebaseUser firebaseUser;

  const SecondRegisteration({Key key, this.firebaseUser}) : super(key: key);

  @override
  _SecondRegisterationState createState() => _SecondRegisterationState();
}

class _SecondRegisterationState extends State<SecondRegisteration> {
  final CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  StorageReference storageReference = FirebaseStorage.instance.ref();
  GlobalKey _circleAvatar = GlobalKey();
  FacebookLogin facebookLogin = FacebookLogin();
  ImagePicker picker = ImagePicker();
  UserModel current_user;
  File _imageSelected;
  var imageOfUser;

  @override
  void initState() {
    super.initState();
     currentUser = widget.firebaseUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أكمل عملية التسجيل', style: TextStyle( color: Colors.white, fontFamily: 'Dubai')),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () => pushAndRemoveUntilPage(context, Home(currentUser: currentUser)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'التالي',
                  style: TextStyle(fontFamily: 'Dubai', color: Colors.white, fontSize: 19),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'أختار صورة حسابك الشخصي',
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 25,
                color: Colors.grey.shade600
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  key: _circleAvatar,
                  radius: 93,
                  backgroundColor: AppColors.cGreen,
                  child: ClipOval(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: previewImage(),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SubmitButton(color: AppColors.cFacebookColor,
                    title: "اختار نفس صورة حسابك على الفيسبوك", onTap: faceBookLoginButton),
                SizedBox(height: 15),
                SubmitButton(color: AppColors.cBlack,
                    title: "اختار صورة من جهازك", onTap: getImageFromPhone, icon: Icon(Icons.add_a_photo)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void faceBookLoginButton() async {
    final FacebookLoginResult result =
    await facebookLogin.logIn(['email']);
    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,email,first_name,last_name,picture.width(800).height(800),birthday&access_token=${result
                .accessToken.token}');
        var profile = json.decode(graphResponse.body);
        setState(() {
          imageOfUser = profile['picture']['data']['url'];
        });
        usersRef.document(GlobalVariable.currentUserId).updateData({
          'fbName': profile['name'],
          'fbEmail': profile['email'],
          'fbAccountId': profile['id'],
          'birthday': profile['birthday'],
          'profilePicture': profile['picture']['data']['url'],
        });
        DocumentSnapshot doc = await usersRef.document(result.accessToken.userId).get();
        doc = await usersRef.document(result.accessToken.userId).get();
        current_user = UserModel.fromDocument(doc);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future getImageFromPhone () async {
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    setState(() {
      _imageSelected = File(pickedImage.path);
    });
    uploadPhoto(context, "Profile Pictures", _imageSelected).then((photoUrl) {
      usersRef.document(GlobalVariable.currentUserId).updateData({
        'profilePicture': photoUrl,
      });
      setState(() {
        imageOfUser = photoUrl;
      });
    });

  }

  // Preview Selected Image either From Facebook or From Storage
  dynamic previewImage() {
    if (imageOfUser != null) {
      return Image.network(imageOfUser, fit: BoxFit.fill);
    } else {
      return Container (color: Colors.grey.shade400);
    }
  }
}
