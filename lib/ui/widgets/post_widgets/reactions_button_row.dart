import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:share/share.dart';

class ReactionsButtonRow extends StatelessWidget {
  final Widget image;
  final Widget label;
  ReactionsButtonRow({this.image, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
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
  final String authorId;
  final String postId;
  final String postBody;
  Map ameenReaction;
  int ameenCount;
  static int counter;

  ReactionsButtons(
      {Key key,
      @required this.ameenReaction,
      @required this.ameenCount,
      @required this.authorId,
      @required this.postId,
      @required this.postBody})
      : super(key: key);

  @override
  ReactionsButtonsState createState() => ReactionsButtonsState(
      ameenReaction: this.ameenReaction,
      ameenCount: this.ameenCount,
      authorId: this.authorId,
      postBody: this.postBody,
      postId: this.postId);
}

class ReactionsButtonsState extends State<ReactionsButtons>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ReactionsButtons> {
  String authorId;
  String postId;
  String postBody;
  Map ameenReaction;
  int ameenCount;

  ReactionsButtonsState(
      {@required this.ameenReaction,
      @required this.ameenCount,
      @required this.authorId,
      @required this.postId,
      @required this.postBody,
      });

  UserModel user;
  dynamic userData;
  String userId;
  bool isPressed;
  int counter;

  // Reactions Icon
  final ameenImage = "assets/images/pray_icon.png";
  final commentImage = "assets/images/comment.png";
  final shareImage = "assets/images/share_icon.png";

  // Reaction Counter
  var ameenCounter;
  var recommendCounter;
  var forbiddenCounter;
  var totalReactions;

  var logger = Logger();

  int durationAnimationBtnShortPress = 500;
  //Animation
  Animation zoomIconAmeenInBtn2, tiltIconAmeenInBtn2;
  AnimationController animControlBtnShortPress;

  @override
  void initState() {
    super.initState();
    _getUserData();
    userId = currentUser.uid;
    isPressed = ameenReaction[userId] == true;
    initAmeenBtn();
  }


  @override
  void dispose() {
    super.dispose();
    animControlBtnShortPress.dispose();
  }

  initAmeenBtn() {
    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconAmeenInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconAmeenInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);
    zoomIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
  }

  // Get user data
  _getUserData() {
    userData = getCurrentUserData(userId: currentUser.uid);
    userData.then((doc) =>  user = UserModel.fromDocument(doc));

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        children: <Widget>[

          //Ameen Button
          InkWell(
              child: ReactionsButtonRow(
                image: Transform.scale(
                  scale: (isPressed)
                      ? handleOutputRangeZoomInIconAmeen(
                      zoomIconAmeenInBtn2.value)
                      : zoomIconAmeenInBtn2.value,
                  child: Transform.rotate(
                    angle: (isPressed)
                        ? handleOutputRangeTiltIconAmeen(
                        tiltIconAmeenInBtn2.value)
                        : tiltIconAmeenInBtn2.value,
                    child: Image.asset(ameenImage,
                        color: (isPressed)
                            ? AppColors.cGreen
                            : AppColors.cTextColor,
                        fit: BoxFit.contain,
                        width: 20,
                        height: 20),
                  ),
                ),
                label: Transform.scale(
                  scale: handleOutputRangeZoomInIconAmeen(
                      zoomIconAmeenInBtn2.value),
                  child: Text(AppLocalizations.of(context).amen,
                      style: TextStyle(
                        fontFamily: 'Dubai',
                        fontSize: 13,
                        color: (isPressed)
                            ? AppColors.cGreen
                            : AppColors.cTextColor,
                        fontWeight:
                        (isPressed) ? FontWeight.w600 : FontWeight.normal,
                      )),
                ),
              ),
              onTap: handleAmeenReact),

          //Comment Button
          InkWell(
            onTap: () => pushPage(context, PostPage(postId: postId, authorId: authorId, authorName: user.username)),
            child: ReactionsButtonRow(
              image: Image.asset(commentImage, width: 20, height: 20),
              label: Text(AppLocalizations.of(context).comment,
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontSize: 13,
                    color: AppColors.cTextColor,
                  )),
            ),
          ),

          //Share Button
          InkWell(
            onTap: () {
              final RenderBox box = context.findRenderObject();
              Share.share(""" ${widget.postBody} 
              
             ${AppLocalizations.of(context).pastedbyAmen} """,
                  sharePositionOrigin:
                  box.localToGlobal(Offset.zero) &
                  box.size);
            },
            child: ReactionsButtonRow(
              image: Image.asset(shareImage, width: 20, height: 20),
              label: Text(AppLocalizations.of(context).share,
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontSize: 13,
                    color: AppColors.cTextColor,
                  )),
            ),
          ),

        ],
      ),
    );
  }

  void handleAmeenReact() {
    isPressed = ameenReaction[userId] == true;
    if (!isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'ameen.$userId': true});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'ameen.$userId': true});

      addReactionToActivityFeed();

      setState(() {
        isPressed = true;
        ameenCount += 1;
        ameenReaction[userId] = true;
        animControlBtnShortPress.forward();
      });
    } else if (isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'ameen.$userId': false});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'ameen.$userId': false});

      deleteReactionToActivityFeed();
      setState(() {
        isPressed = false;
        ameenCount -= 1;
        ameenReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

  void addReactionToActivityFeed() {
    bool isNotPostOwner = currentUser.uid != authorId;
    if (isNotPostOwner) {
      DbRefs.activityFeedRef
          .document(authorId)
          .collection('feedItems')
          .document(postId)
          .setData({
        'type': 'amen',
        'username': user.username,
        'userId': userId,
        'profilePicture': user.profilePicture,
        'postId': postId,
        'created_at': DateTime.now()
      });
    }
  }

  void deleteReactionToActivityFeed() {
    bool isNotPostOwner = currentUser.uid != authorId;
    if (isNotPostOwner) {
      DbRefs.activityFeedRef
          .document(authorId)
          .collection('feedItems')
          .document(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
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

  double handleOutputRangeZoomInIconAmeen(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
