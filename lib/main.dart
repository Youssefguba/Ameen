import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void setupLocator(){
    GetIt.I.registerLazySingleton(() => PostsService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

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
      home: Home(),
    );
  }
}
