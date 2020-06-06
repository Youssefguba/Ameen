import 'dart:ui';
import 'package:ameen/ui/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        child: FlatButton(
          child: Text('تسجيل خروج', style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 18)),
          color: Colors.redAccent,
          disabledColor: Colors.redAccent,
          shape: StadiumBorder(),
          splashColor: Colors.red.shade800,
          onPressed: () async {
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            await http.get(Api.API + 'auth/logout')
                .then((response) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext buildContext) => Login()),
                      (route) => false);
            });
            await sharedPreferences.clear();
          },
        ),
      ),
    );
  }

  void signOut() async {

  }
}
