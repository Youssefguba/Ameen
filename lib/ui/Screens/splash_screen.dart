import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:ameen/ui/Screens/ways_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _logoController;
  Animation _animationLogo;

  @override
  void initState() {
    super.initState();
    initAnimationOfLogo();
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
  }

  initAnimationOfLogo() {
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _logoController.addListener(() {
      setState(() {});
    });
    _animationLogo =
        Tween<double>(begin: 2.0, end: 1.2).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));
    _logoController.forward();

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        pushPage(context, Wrapper());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: AnimatedContainer(
            curve: Curves.easeIn,
            duration: Duration(seconds: 2),
            width: 180,
            height: 180,
            decoration: BoxDecoration(color: Colors.white),
            child: ScaleTransition(
                scale: _animationLogo, child: Image.asset(AppImages.appLogo)),
          ),
        ),
      ),
    );
  }
}
