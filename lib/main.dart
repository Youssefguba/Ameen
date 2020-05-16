import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/splash_screen.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_box.dart';
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
      home: SplashScreen(),
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
