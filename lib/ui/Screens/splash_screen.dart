import 'package:ameen/ui/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigate (){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Home(),
      ));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child:  SizedBox(
            child: ColorizeAnimatedTextKit(
                isRepeatingAnimation: false,
                onFinished: navigate,
                speed: Duration(milliseconds: 900),
                text: ["آمين", "Amen"],
                textStyle: TextStyle(
                  color: myColors.cGreen,
                  fontSize: 80.0,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),
                colors: [Colors.white, myColors.cGreen],
                textAlign: TextAlign.start,
                alignment:
                AlignmentDirectional.topEnd // or Alignment.topLeft
            ),
          ),
          ),
        ),
    );


  }
}

