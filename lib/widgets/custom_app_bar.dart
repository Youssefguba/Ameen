import 'package:flutter/material.dart';

Widget CustomAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        "الصفحة الرئيسية",
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.w700,
          color: Colors.green.shade700,
        ),
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.notifications_none),
        tooltip: "الآشعارات",
      )
    ],
  );
}