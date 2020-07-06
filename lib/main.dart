import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.cGreen,
      statusBarIconBrightness: Brightness.dark,
    ));

    return StreamProvider<UserModel>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'),
          Locale('en', 'US'),
        ],
        builder: (context, child) {
              return ScrollConfiguration(
                behavior: RemoveGlowEffect(),
                child: child,
              );
            },
            title: 'آمين',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(62, 146, 42, 1),
            ),
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
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
