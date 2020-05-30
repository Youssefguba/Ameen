import 'package:ameen/blocs/global/global.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/reaction_model.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactionsButtonRow extends StatelessWidget {
  Widget image;
  Widget label;
  ReactionsButtonRow({this.image, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.0),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
            child: label,
          ),
          image,
          VerticalDivider(width: 5.0, color: Colors.transparent, indent: 1.0),
        ],
      ),
    );
  }
}

/*
 *  Action Buttons Widgets like..
 *       (Like, Comment, Share)
 **/
class ReactionsButtons extends StatefulWidget {
  @override
  ReactionsButtonsState createState() => ReactionsButtonsState();
}

class ReactionsButtonsState extends State<ReactionsButtons> with TickerProviderStateMixin {
  PostsService get services => GetIt.I<PostsService>();
  // Reactions Icon
  final ameenImage = "assets/images/pray_icon.png";
  final commentImage = "assets/images/comment.png";
  final shareImage = "assets/images/share_icon.png";

  // Reaction Counter
  var ameenCounter;
  var recommendCounter;
  var forbiddenCounter;
  var totalReactions;
  AmeenReaction ameenReaction;

  bool isPressed = false;
  final ameenReact = AmeenReaction();
  var logger = Logger();

  int durationAnimationBtnShortPress = 500;
  //Animation
  Animation zoomIconAmeenInBtn2, tiltIconAmeenInBtn2;
  AnimationController animControlBtnShortPress;


  @override
  void initState() {
    super.initState();
    initAmeenBtn();
  }

  initAmeenBtn(){
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

  @override
  Widget build(BuildContext context) {
    final PostData postData = InheritedPostModel.of(context).postData;
    ameenCounter     = postData.ameenReaction.length;
    recommendCounter = postData.recommendReaction.length;
    forbiddenCounter = postData.forbiddenReaction.length;
    totalReactions =  ameenCounter + recommendCounter + forbiddenCounter;

      setState(() {
      });

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),

      // Reactions Buttons => [Ameen - Comment - Share]
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          //Ameen Button
          InkWell(
            child: ReactionsButtonRow(
              image: Transform.scale(
                scale: (isPressed ) ? handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value) : zoomIconAmeenInBtn2.value,
                child: Transform.rotate(
                  angle: (isPressed ) ?  handleOutputRangeTiltIconAmeen(tiltIconAmeenInBtn2.value) : tiltIconAmeenInBtn2.value,
                  child: Image.asset(ameenImage,
                      color: (isPressed) ? MyColors.cGreen : MyColors.cTextColor,
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20
                  ),
                ),
              ),
              label: Transform.scale(
                scale: handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value),
                child: Text("آمين",
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 13,
                      color: (isPressed) ? MyColors.cGreen : MyColors.cTextColor,
                      fontWeight: (isPressed) ? FontWeight.w600 : FontWeight.normal,
                    )),
              ),
            ),
            onTap: ()  {
              if (!isPressed) {
                setState(() {
                  isPressed = true;
                  services.ameenReact(postData.postId, ameenReact);
                  animControlBtnShortPress.forward();

                });
              } else {
                setState(()  {
                  isPressed = false;
                  animControlBtnShortPress.reverse();
                  services.removeAmeenReact(postData.postId, GlobalVariable.currentUserId);
                });
              }
            },
          ),

          //Comment Button
          ReactionsButtonRow(
            image:
            Image.asset(commentImage, width: 20, height: 20),
            label: Text("تعليق",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: MyColors.cTextColor,
                )),
          ),

          //Share Button
          ReactionsButtonRow(
            image: Image.asset(shareImage,
                width: 20, height: 20),
            label: Text("مشاركة",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: MyColors.cTextColor,
                )),
          ),
        ],
      ),
    );
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

  double handleOutputRangeZoomInIconAmeen(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }
}
