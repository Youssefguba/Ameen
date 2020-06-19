import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralSettingPage extends StatelessWidget {
  FirebaseUser currentUser;
  GeneralSettingPage({Key key, @required this.currentUser}) : super(key: key);
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.Settings,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Dubai')),
        leading: IconButton(
          icon: ImageIcon(AssetImage(AppIcons.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          disabledColor: AppColors.cBackground,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            ListTile(
              title: Text(AppTexts.ProfileSettings,
                  style: TextStyle(fontFamily: 'Dubai', fontSize: 15)),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text(AppTexts.Logout,
                  style: TextStyle(fontFamily: 'Dubai', fontSize: 15)),
              leading: Icon(Icons.exit_to_app),
              onTap: () async {
                await auth.signOut();
                pushAndRemoveUntilPage(context, Login());
              },
            ),
          ],
        ),
      ),
    );
  }
}
