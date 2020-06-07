import 'dart:ui';
import 'package:ameen/ui/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/authentication.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Texts.Settings,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Dubai')),
        leading: IconButton(
          icon: ImageIcon(AssetImage(MyIcons.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          disabledColor: MyColors.cBackground,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.topCenter,

        // Sign out button
        child: FlatButton(
          child: Text('تسجيل خروج', style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 18)),
          color: Colors.redAccent,
          disabledColor: Colors.redAccent,
          shape: StadiumBorder(),
          splashColor: Colors.red.shade800,
          onPressed: () async { await auth.signOut(); },
        ),
      ),
    );
  }
}
