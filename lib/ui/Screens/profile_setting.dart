import 'dart:ui';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/authentication.dart';

class ProfileSetting extends StatefulWidget {
  FirebaseUser currentUser;
  ProfileSetting({Key key, @required this.currentUser}): super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService auth = AuthService();
  UserModel user;

  String userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    _fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
    setState(() => isLoading = false);
  }

  void _fetchUserData() async {
    setState(() => isLoading = true);
    DocumentSnapshot doc = await usersRef.document(userId).get();
    user = UserModel.fromDocSnapshot(doc);
    _usernameController.text = user.username;
    setState(() => user.username );
    setState(() => isLoading = false);

  }

  void _updateUserData() async {
    if(_formKey.currentState.validate()) {
      usersRef.document(userId).updateData({
        'username': _usernameController.text
      });
      SnackBar snackbar = SnackBar(content: Text('تم تغيير الإسم بنجاح'));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editYourProfile,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Dubai')),
        leading: IconButton(
          icon: ImageIcon(AssetImage(AppImages.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          disabledColor: AppColors.cBackground,
        ),
      ),
      body: (isLoading) ? RefreshProgress() :
      Container(
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [

                // Profile Picture of User
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.profilePicture),
                  radius: 80,
                  backgroundColor: AppColors.cGreen,
                ),
                SizedBox(height: 8),

                Text(
                  user.username,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Dubai', fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Name of User
                Form(
                  key: _formKey,
                  child: EntryField(
                    AppLocalizations.of(context).username,
                    labelText:AppLocalizations.of(context).username,
                    editingController: _usernameController,
                    maxLengthLetters: 25,
                    validator: (val) => val.trim().length < 2 || val.isEmpty ? 'لا تترك خانة الإسم فارغة' : null,
                  ),
                ),
                SizedBox(height: 30),

                // Update data button
                SubmitButton(color: AppColors.cGreen, title: AppLocalizations.of(context).updateData, onTap: () => _updateUserData() ),
                SizedBox(height: 30),

                // Logout Button
//                FlatButton(
//                  child: Text('تسجيل خروج', style: TextStyle(color: Colors.white, fontFamily: 'Dubai', fontSize: 18)),
//                  color: Colors.redAccent,
//                  disabledColor: Colors.redAccent,
//                  shape: StadiumBorder(),
//                  splashColor: Colors.red.shade800,
//                  onPressed: () async { await auth.signOut(); },
//                ),
              ],
            ),
          ),
        ),
        ),
    );
  }
}
