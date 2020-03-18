import 'package:ameen/Screens/news_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
         statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Ameen آميين',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home:  NewsFeed(),
    );

  }
}

