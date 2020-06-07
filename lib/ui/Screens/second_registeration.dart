import 'dart:convert';

import 'package:ameen/blocs/global/global.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;


class SecondRegisteration extends StatelessWidget {
  final CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  final _cardKey = GlobalKey();
  FacebookLogin facebookLogin = FacebookLogin();

  UserModel currentUser;
  var imageOfUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أكمل عملية التسجيل', style: TextStyle( color: Colors.white, fontFamily: 'Dubai')),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: 220,
              height: 220,
              child: Card(
                key: _cardKey,
                child: imageOfUser== null ? Container(color: Colors.grey) : Image.network(imageOfUser)  ,
              ),
            ),
            SubmitButton(MyColors.cFacebookColor,
                "التسجيل بواسطة الفيسبوك", faceBookLoginButton),
          ],
        ),
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
        imageOfUser = profile['picture']['data']['url'];
        usersRef.document(GlobalVariable.currentUserId ).updateData({
          'fbName': profile['name'],
          'fbEmail': profile['email'],
          'fbAccountId': profile['id'],
          'birthday': profile['birthday'],
          'profilePicture': profile['picture']['data']['url'],
        });
        DocumentSnapshot doc = await usersRef.document(result.accessToken.userId).get();
        doc = await usersRef.document(result.accessToken.userId).get();
        currentUser = UserModel.fromDocument(doc);

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
}
