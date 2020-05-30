import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;

class Reaction extends StatelessWidget {
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
    body: Center(child: ReactionsBox()));
  }
}



class ReactionsBox extends StatefulWidget  {
  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox> with TickerProviderStateMixin {
  AudioPlayer audioPlayer;


  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationBox = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  Duration durationOfLongPress = Duration(milliseconds: 250);

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

  Timer holdTimer;

  bool isLongPress = false;
  bool isAmeen = false;
  bool isDragging = false;
  // 0 = nothing, 1 = Ameen, 2 = Recommend, 3 = Forbidden
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  // 0 = nothing, 1 = Ameen, 2 = Recommend, 3 = Forbidden
  int whichIconUserChoose = 0;

  @override
  void initState() {
    super.initState();

    initAnimationBtnAmeen();
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
  // Button Ameen
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
      onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,

      child: Container(
        child: Stack(
          children: <Widget>[
            renderAmeenBtn(),
            renderBox(),

          ],
        ),
      ),
    );
  }

  Widget renderBox() {
      return Opacity(
        opacity: this.fadeInBox.value,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  // LTRB
                  offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)),
            ],
          ),
          child: renderIcons(),
        ),
      );
  }

  Widget renderIcons(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 90,
        padding: EdgeInsets.all(5),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Ameen Icon
            Transform.scale(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pray_color.png',
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'آمين',
                      style: mytextStyle.reactionsButtonsTextStyle,
                    )
                  ],
                ),
              ),
              scale: isDragging
                  ? (currentIconFocus == 1
                  ? this.zoomIconChosen.value
                  : (previousIconFocus == 1
                  ? this.zoomIconNotChosen.value
                  : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                  : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconAmeen.value,
            ),

            //Recommend Icon
            Transform.scale(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/recommend_color.png',
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'أرشحه للجميع',
                      style: mytextStyle.reactionsButtonsTextStyle,
                    )
                  ],
                ),
              ),
              scale: isDragging
                  ? (currentIconFocus == 2
                  ? this.zoomIconChosen.value
                  : (previousIconFocus == 2
                  ? this.zoomIconNotChosen.value
                  : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                  : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconRecommend.value,
            ),

            //Forbidden Icon
            Transform.scale(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/forbidden_color.png',
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'إحذر هذا الدعاء',
                      style: mytextStyle.reactionsButtonsTextStyle,
                    )
                  ],
                ),
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
        ),

    );
  }

  Widget renderAmeenBtn(){
    return GestureDetector(
      onTapDown: onTapDownBtn,
      onTapUp: onTapUpBtn,
      onTap: onTapBtn,
      child:Container(
        alignment: Alignment.centerRight,
        height: 280,
          width: 150,
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 7.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(1.0)),

              // Text Ameen
              Container(
                margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                child: Transform.scale(
                  child: Text(
                    getTextBtn(),
                    style: TextStyle(
                      color: getColorTextBtn(),
                      fontSize: 12.0,
                      fontWeight: getFontWeight(),
                    ),
                  ),
                  scale:
                  !isLongPress ? handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value) : zoomTextAmeenInBtn.value,
                ),
              ),

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
                  angle: !isLongPress ? handleOutputRangeTiltIconAmeen(tiltIconAmeenInBtn2.value) : tiltIconAmeenInBtn.value,
                ),
                scale: !isLongPress ? handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value) : zoomIconAmeenInBtn.value,
              ),

            ],
          ),
        ),

    );
  }

  String getImageIconBtn() {
    if (!isLongPress && isAmeen) {
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

  FontWeight getFontWeight() {
    if (!isLongPress && isAmeen) {
      return FontWeight.bold;
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return FontWeight.normal;
    }
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isAmeen)) {
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

  Color getTintColorIconBtn() {
    if (!isLongPress && isAmeen) {
      return MyColors.green;
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return Colors.grey;
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

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isAmeen = !isAmeen;
      } else {
        whichIconUserChoose = 0;
      }
      if (isAmeen) {
        playSound('short_press_like.mp3');
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
    }
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

    animControlBox.reverse();

  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationOfLongPress, showBox);
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
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconAmeen = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconRecommendUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconRecommend = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconForbiddenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconForbidden = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconAmeenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconAmeen = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconRecommendUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconRecommend = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconForbiddenUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconForbidden = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;

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

      if (dragUpdateDetail.globalPosition.dx >= 20 && dragUpdateDetail.globalPosition.dx < 80) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 81 && dragUpdateDetail.globalPosition.dx < 120) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 120 && dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
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


  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
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
