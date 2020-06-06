import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/services/authentication.dart';
import 'package:ameen/services/user_service.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => UserService());
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
      statusBarColor: MyColors.cGreen,
      statusBarIconBrightness: Brightness.dark,
    ));

    return StreamProvider<UserModel>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RemoveGlowEffect(),
            child: child,
          );
        },
        title: 'Ameen آميين',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(62, 146, 42, 1),
        ),
        debugShowCheckedModeBanner: false,
        home: WaysPage(),
      ),
    );
  }
}

/*
* To Remove Glow Effect from the entire App.
* */
class RemoveGlowEffect extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
