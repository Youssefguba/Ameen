import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) {
      setState(() {
        currentUser = user;
      });
      if(user == null) {
        pushAndRemoveUntilPage(context, Login()) ;
      } else {
        //TODO Check if the user has photo or not to redirect to the second registeration page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.cGreen,
        body: Container(),
      );
    } else {
      return Home(currentUser: currentUser);
    }
  }
}
