import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameen/ui/Screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: removeGlowEffect(),
          child: child,
        );
      },
      title: 'Ameen آميين',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(62, 146, 42, 1),
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

/*
* To Remove Glow Effect from the entire App.
* */
class removeGlowEffect extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
