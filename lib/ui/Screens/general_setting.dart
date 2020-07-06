import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/profile_setting.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/localizations.dart';
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
        title: Text(AppLocalizations.of(context).settings,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Dubai')),
        leading: IconButton(
          iconSize: 18,
          icon: ImageIcon(AssetImage(AppImages.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          disabledColor: AppColors.cBackground,
        ),
      ),
      body: Container(
        child: Column(
          children: [

            // Profile Setting
            ListTile(
              title: Text(AppLocalizations.of(context).editYourProfile,
                  style: TextStyle(fontFamily: 'Dubai', fontSize: 15)),
              leading: Icon(Icons.person),
              onTap: () => pushPage(context, ProfileSetting(currentUser: currentUser,)),
            ),

            // Logout
            ListTile(
              title: Text(AppLocalizations.of(context).logout,
                  style: TextStyle(fontFamily: 'Dubai', fontSize: 15)),
              leading: Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                pushAndRemoveUntilPage(context, Wrapper());
              },
            ),
          ],
        ),
      ),
    );
  }
}
