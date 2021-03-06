import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser currentUser;
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FirebaseAuth _auth = FirebaseAuth.instance;
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
        pushAndRemoveUntilPage(context, Home(currentUser: currentUser)) ;

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
