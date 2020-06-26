import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FbReactionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'FB REACTION',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: FbReaction()
    );
  }
}

class FbReaction extends StatefulWidget {
  @override
  createState() => FbReactionState();
}

class FbReactionState extends State<FbReaction> with TickerProviderStateMixin {
  AudioPlayer audioPlayer;

  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  // For long press btn
  AnimationController animControlBtnLongPress, animControlBox;
  Animation zoomIconAmeenInBtn, tiltIconAmeenInBtn, zoomTextAmeenInBtn;
  Animation fadeInBox;
  Animation moveRightGroupIcon;
  Animation pushIconAmeenUp, pushIconRecommendUp, pushIconForbiddenUp, pushIconWowUp, pushIconSadUp, pushIconAngryUp;
  Animation zoomIconAmeen, zoomIconRecommend, zoomIconForbidden, zoomIconWow, zoomIconSad, zoomIconAngry;

  // For short press btn
  AnimationController animControlBtnShortPress;
  Animation zoomIconAmeenInBtn2, tiltIconAmeenInBtn2;

  // For zoom icon when drag
  AnimationController animControlIconWhenDrag;
  AnimationController animControlIconWhenDragInside;
  AnimationController animControlIconWhenDragOutside;
  AnimationController animControlBoxWhenDragOutside;
  Animation zoomIconChosen, zoomIconNotChosen;
  Animation zoomIconWhenDragOutside;
  Animation zoomIconWhenDragInside;
  Animation zoomBoxWhenDragOutside;
  Animation zoomBoxIcon;

  // For jump icon when release
  AnimationController animControlIconWhenRelease;
  Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  Animation moveLeftIconAmeenWhenRelease,
      moveLeftIconRecommendWhenRelease,
      moveLeftIconForbiddenWhenRelease;

  Duration durationLongPress = Duration(milliseconds: 250);
  Timer holdTimer;
  bool isLongPress = false;
  bool isLiked = false;

  // 0 = nothing, 1 = Ameen, 2 = Recommend, 3 = Forbidden
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = Ameen, 2 = Recommend, 3 = Forbidden
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    // Button Ameen
    initAnimationBtnAmeen();

    // Box and Icons
    initAnimationBoxAndIcons();

    // Icon when drag
    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();
  }

  initAnimationBtnAmeen() {
    // long press
    animControlBtnLongPress =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconAmeenInBtn = Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconAmeenInBtn = Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextAmeenInBtn = Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconAmeenInBtn.addListener(() {
      setState(() {});
    });
    tiltIconAmeenInBtn.addListener(() {
      setState(() {});
    });
    zoomTextAmeenInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconAmeenInBtn2 = Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconAmeenInBtn2 = Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Icons
    pushIconAmeenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconAmeen = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconRecommendUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconRecommend = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconForbiddenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconForbidden = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconAmeenUp.addListener(() {
      setState(() {});
    });
    zoomIconAmeen.addListener(() {
      setState(() {});
    });
    pushIconRecommendUp.addListener(() {
      setState(() {});
    });
    zoomIconRecommend.addListener(() {
      setState(() {});
    });
    pushIconForbiddenUp.addListener(() {
      setState(() {});
    });
    zoomIconForbidden.addListener(() {
      setState(() {});
    });
    pushIconWowUp.addListener(() {
      setState(() {});
    });
    zoomIconWow.addListener(() {
      setState(() {});
    });
    pushIconSadUp.addListener(() {
      setState(() {});
    });
    zoomIconSad.addListener(() {
      setState(() {});
    });
    pushIconAngryUp.addListener(() {
      setState(() {});
    });
    zoomIconAngry.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen = Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen = Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon = Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside = Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside = Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside = Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease =
        AnimationController(vsync: this, duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0)
        .animate(CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0)
        .animate(CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconAmeenWhenRelease = Tween(begin: 20.0, end: 10.0)
        .animate(CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconRecommendWhenRelease = Tween(begin: 68.0, end: 10.0)
        .animate(CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconForbiddenWhenRelease = Tween(begin: 116.0, end: 10.0)
        .animate(CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconAmeenWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconRecommendWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconForbiddenWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          // Just a top space
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20.0,
          ),

          // main content
          Container(
            child: Stack(
              children: <Widget>[
                // Box and icons
                Stack(
                  children: <Widget>[
                    // Box
                    renderBox(),
                    // Icons
                    renderIcons(),
                  ],
                  alignment: Alignment.topRight,
                ),

                // Button Ameen
                renderBtnAmeen(),


                // Icons when jump
                // Icon Ameen
                whichIconUserChoose == 1 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/images/pray_color.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconAmeenWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon Recommend
                whichIconUserChoose == 2 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/images/recommend_color.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconRecommendWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon Forbidden
                whichIconUserChoose == 3 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/images/forbidden_color.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconForbiddenWhenRelease.value,
                        ),
                      )
                    : Container(),

              ],
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            // Area of the content can drag
            // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
            width: MediaQuery.of(context).size.width,
            height: 350.0,
          ),
        ],
      ),
      onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
    );
  }

  Widget renderBox() {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey[300], width: 0.3),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                // LTRB
                offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)),
          ],
        ),
        width: 220.0,
        height: isDragging
            ? (previousIconFocus == 0 ? this.zoomBoxIcon.value : 40.0)
            : isDraggingOutside ? this.zoomBoxWhenDragOutside.value : 50.0,
        margin: EdgeInsets.only(bottom: 250.0, left: 10.0),
      ),
      opacity: this.fadeInBox.value,
    );
  }

  Widget renderIcons() {
    return Container(
      child: Row(
        children: <Widget>[
          // icon Ameen
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? Container(
                          child: Text(
                            'آمين',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/pray_color.png',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconAmeenUp.value),
              width: 30.0,
              height: currentIconFocus == 1 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 1
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconAmeen.value,
          ),

          // icon recommend
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? Container(
                          child: Text(
                            'أرشحه للجميع',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/recommend_color.png',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconRecommendUp.value),
              width: 60.0,
              height: currentIconFocus == 2 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 2
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 2
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconRecommend.value,
          ),

          // icon Forbidden/ Stop
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? Container(
                          child: Text(
                            'أحذر هذا الدعاء',
                            style: TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/images/forbidden_color.png',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconForbiddenUp.value),
              width: 60.0,
              height: currentIconFocus == 3 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 3
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 3
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconForbidden.value,
          ),

        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 150.0,
      height: 250.0,
      margin: EdgeInsets.only(right: this.moveRightGroupIcon.value, bottom: 140.0),
      // uncomment here to see area of draggable
//       color: Colors.amber.withOpacity(0.5),
    );
  }

  Widget renderBtnAmeen() {
    return Container(
      child: GestureDetector(
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        onTap: onTapBtn,
        child: Container(
          child: Row(
            children: <Widget>[
              // Icon Ameen
              Transform.scale(
                child: Transform.rotate(
                  child: Image.asset(
                    getImageIconBtn(),
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.contain,
                    color: getTintColorIconBtn(),
                  ),
                  angle:
                      !isLongPress ? handleOutputRangeTiltIconAmeen(tiltIconAmeenInBtn2.value) : tiltIconAmeenInBtn.value,
                ),
                scale:
                    !isLongPress ? handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value) : zoomIconAmeenInBtn.value,
              ),
              // Text Ameen
              Transform.scale(
                child: Text(
                  getTextBtn(),
                  style: TextStyle(
                    color: getColorTextBtn(),
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                scale:
                    !isLongPress ? handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value) : zoomTextAmeenInBtn.value,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.all(0.0),
          color: Colors.transparent,
        ),
      ),
      width: 100.0,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(4.0),
//        color: Colors.white,
////        border: Border.all(color: getColorBorderBtn()),
//      ),
//      margin: EdgeInsets.only(top: 19.0),
    );
  }

  String getTextBtn() {
    if (isDragging) {
      return 'آمين';
    }
    switch (whichIconUserChoose) {
      case 1:
        return 'آمين';
      case 2:
        return 'أرشحه للجميع';
      case 3:
        return 'إحذر هذا الدعاء';
      default:
        return 'آمين';
    }
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xF23E922A);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xF23E922A);
        case 2:
          return Color(0xffFFD96A);
        case 3:
          return Colors.red;
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return 'assets/images/pray_color.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return 'assets/images/pray_color.png';
        case 2:
          return 'assets/images/recommend_color.png';
        case 3:
          return 'assets/images/forbidden_color.png';
        default:
          return 'assets/images/pray_icon.png';
      }
    } else {
      return 'assets/images/pray_icon.png';
    }
  }

  Color getTintColorIconBtn() {
    if (!isLongPress && isLiked) {
      return Color(0xF23E922A);
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return Colors.grey;
    }
  }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color getColorBorderBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey[400];
    }
  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 && dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 && dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 && dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 && dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 && dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 && dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 && dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails tapUpDetail) {
    if (isLongPress) {
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
    }

    Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();

    setReverseValue();
    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        playSound('short_press_like.mp3');
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
    }
  }


  double handleOutputRangeZoomInIconAmeen(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double handleOutputRangeTiltIconAmeen(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void showBox() {
    playSound('box_up.mp3');
    isLongPress = true;

    animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon
  void setReverseValue() {
    // Icons
    pushIconAmeenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconAmeen = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconRecommendUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconRecommend = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconForbiddenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconForbidden = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconAmeenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconAmeen = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconRecommendUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconRecommend = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconForbiddenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconForbidden = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

  }

  Future playSound(String nameSound) async {
    // Sometimes multiple sound will play the same time, so we'll stop all before play the
    await audioPlayer.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$nameSound');
    await file.writeAsBytes((await loadAsset(nameSound)).buffer.asUint8List());
    await audioPlayer.play(file.path, isLocal: true);
  }

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('assets/sounds/$nameSound');
  }
}
