import 'package:ameen/ui/Screens/activity_feed_page.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';

/*
* This is the Customized Appbar in Home Screen (NewsFeed)
* */

Widget customAppBar(BuildContext context, FirebaseUser currentUser) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context).home,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.w700,
          color:  AppColors.green[700],
        ),
      ),
    ),
    actions: <Widget>[
      IconButton(
        color: Colors.black,
        icon: Icon(Icons.notifications_none),
        tooltip: AppLocalizations.of(context).notification,
        onPressed: () => pushPage(context, ActivityFeed(currentUser: currentUser)),

      )
    ],

  );
}