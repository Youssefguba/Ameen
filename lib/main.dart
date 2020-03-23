import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/Screens/test.dart';
import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cGreen,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Ameen آميين',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(62, 146, 42, 1),
      ),
      debugShowCheckedModeBanner: false,
      home: NewsFeed(),
    );
  }
}
