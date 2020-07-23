import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/flutter_reactive_button.dart';
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
      child: LimitedBox(
        maxWidth: double.maxFinite,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
            ),
            Container(width: 20, height: 20, child: image),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                child: label),
            VerticalDivider(width: 5.0, color: Colors.transparent, indent: 1.0),
          ],
        ),
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
  Map recommendReaction;
  Map forbiddenReaction;
  int ameenCount;
  int recommendCount;
  int forbiddenCount;
  static int counter;

  ReactionsButtons(
      {Key key,
      @required this.ameenReaction,
      @required this.ameenCount,
      @required this.recommendCount,
      @required this.forbiddenCount,
      @required this.authorId,
      @required this.postId,
      @required this.postBody,
      @required this.recommendReaction,
      @required this.forbiddenReaction})
      : super(key: key);

  @override
  ReactionsButtonsState createState() => ReactionsButtonsState(
      ameenReaction: this.ameenReaction,
      recommendReaction: this.recommendReaction,
      forbiddenReaction: this.forbiddenReaction,
      ameenCount: this.ameenCount,
      recommendCount: this.recommendCount,
      forbiddenCount: this.forbiddenCount,
      authorId: this.authorId,
      postBody: this.postBody,
      postId: this.postId);
}

class ReactionsButtonsState extends State<ReactionsButtons>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ReactionsButtons> {
  String authorId;
  String postId;
  String postBody;
  Map ameenReaction;
  Map recommendReaction;
  Map forbiddenReaction;
  int ameenCount;
  int recommendCount;
  int forbiddenCount;

  ReactionsButtonsState({
    @required this.ameenReaction,
    @required this.ameenCount,
    @required this.authorId,
    @required this.postId,
    @required this.postBody,
    @required this.recommendReaction,
    @required this.forbiddenReaction,
    @required this.recommendCount,
    @required this.forbiddenCount,
  });

  UserModel user;
  dynamic userData;
  String userId;
  bool isPressed;
  int counter;
  String icons;

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

  var btnStyle = TextStyle(
    fontFamily: 'Dubai',
    fontSize: 13,
    color: AppColors.cTextColor,
  );
  int durationAnimationBtnShortPress = 500;
  //Animation
  Animation zoomIconAmeenInBtn2, tiltIconAmeenInBtn2;
  AnimationController animControlBtnShortPress;

  @override
  void initState() {
    super.initState();
    _getUserData();
    userId = currentUser.uid;
    isPressed = ameenReaction[userId] == true ||
        recommendReaction[userId] == true ||
        forbiddenReaction[userId] == true;

    isUserReact();
    initAmeenBtn();
  }

  isUserReact() {
    setState(() {
      if (ameenReaction[userId] == true) {
        return icons = AppImages.coloredPrayIcon;
      } else if (recommendReaction[userId] == true) {
        return icons = AppImages.coloredRecommendIcon;
      } else if (forbiddenReaction[userId] == true) {
        return icons = AppImages.coloredForbiddenIcon;
      }
      return icons = AppImages.blackPrayIcon;
    });
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
    userData.then((doc) => user = UserModel.fromDocument(doc));
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
          _overlayReactionButtons(),

          //Comment Button
          InkWell(
            onTap: () => pushPage(
                context,
                PostPage(
                    postId: postId,
                    authorId: authorId,
                    authorName: user.username)),
            child: ReactionsButtonRow(
              image: Image.asset(commentImage),
              label: Text(
                AppLocalizations.of(context).comment,
                style: btnStyle,
              ),
            ),
          ),

          //Share Button
          InkWell(
            onTap: () {
              final RenderBox box = context.findRenderObject();
              Share.share(
                  "${widget.postBody} \n ${'تم نقل هذا المنشور بواسطة تطبيق آمين'}",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
            child: ReactionsButtonRow(
                image: Image.asset(shareImage),
                label:
                    Text(AppLocalizations.of(context).share, style: btnStyle)),
          ),
        ],
      ),
    );
  }

  void handleAmeenReact() {
    isPressed = ameenReaction[userId] == true ||
        recommendReaction[userId] == true ||
        forbiddenReaction[userId] == true;

    if (!isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'ameen.$userId': true});

      // Update data in timeline
      DbRefs.timelineRef.document(postId).updateData({'ameen.$userId': true});

      // Add Reaction To Activity Feed of other user.
      addReactionToActivityFeed(
          currentUserId: currentUser.uid,
          authorId: authorId,
          postId: postId,
          username: user.username,
          userId: userId,
          profilePicture: user.profilePicture,
          typeOfReaction: 'ameen');

      setState(() {
        isPressed = ameenReaction[userId] == true;
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
      DbRefs.timelineRef.document(postId).updateData({'ameen.$userId': false});

      // delete Reaction To Activity Feed of other user.
      deleteReactionToActivityFeed(
          currentUserId: currentUser.uid, authorId: authorId, postId: postId);
      setState(() {
        isPressed = ameenReaction[userId] == false;
        ameenCount -= 1;
        ameenReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

  void handleRecommendReact() {
    isPressed = ameenReaction[userId] == true ||
        recommendReaction[userId] == true ||
        forbiddenReaction[userId] == true;

    if (!isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'recommend.$userId': true});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'recommend.$userId': true});

      // Add Reaction To Activity Feed of other user.
      addReactionToActivityFeed(
          currentUserId: currentUser.uid,
          authorId: authorId,
          postId: postId,
          username: user.username,
          userId: userId,
          profilePicture: user.profilePicture,
          typeOfReaction: 'recommend');

      setState(() {
        isPressed = recommendReaction[userId] == true;
        recommendCount += 1;
        recommendReaction[userId] = true;
        animControlBtnShortPress.forward();
      });
    } else if (isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'recommend.$userId': false});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'recommend.$userId': false});

      // delete Reaction To Activity Feed of other user.
      deleteReactionToActivityFeed(
          currentUserId: currentUser.uid, authorId: authorId, postId: postId);

      setState(() {
        isPressed = recommendReaction[userId] == false;
        recommendCount -= 1;
        recommendReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

  void handleForbiddenReact() {
    isPressed = ameenReaction[userId] == true ||
        recommendReaction[userId] == true ||
        forbiddenReaction[userId] == true;

    if (!isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'forbidden.$userId': true});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'forbidden.$userId': true});

      // Add Reaction To Activity Feed of other user.
      addReactionToActivityFeed(
          currentUserId: currentUser.uid,
          authorId: authorId,
          postId: postId,
          username: user.username,
          userId: userId,
          profilePicture: user.profilePicture,
          typeOfReaction: 'forbidden');

      setState(() {
        isPressed = true;
        forbiddenCount += 1;
        forbiddenReaction[userId] = true;
        animControlBtnShortPress.forward();
      });
    } else if (isPressed) {
      // Update data in user profile
      DbRefs.postsRef
          .document(authorId)
          .collection(DatabaseTable.userPosts)
          .document(postId)
          .updateData({'forbidden.$userId': false});

      // Update data in timeline
      DbRefs.timelineRef
          .document(postId)
          .updateData({'forbidden.$userId': false});

      // delete Reaction To Activity Feed of other user.
      deleteReactionToActivityFeed(
          currentUserId: currentUser.uid, authorId: authorId, postId: postId);

      setState(() {
        isPressed = false;
        forbiddenCount -= 1;
        forbiddenReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

  void deleteAllReactions() {
    isPressed = ameenReaction[userId] == true ||
        recommendReaction[userId] == true ||
        forbiddenReaction[userId] == true;

    // Update data in user profile
    DbRefs.postsRef
        .document(authorId)
        .collection(DatabaseTable.userPosts)
        .document(postId)
        .updateData({'forbidden.$userId': false});

    // Update data in user profile
    DbRefs.postsRef
        .document(authorId)
        .collection(DatabaseTable.userPosts)
        .document(postId)
        .updateData({'ameen.$userId': false});

    // Update data in user profile
    DbRefs.postsRef
        .document(authorId)
        .collection(DatabaseTable.userPosts)
        .document(postId)
        .updateData({'recommend.$userId': false});

    // Update data in timeline
    DbRefs.timelineRef.document(postId).updateData({'ameen.$userId': false});
    DbRefs.timelineRef
        .document(postId)
        .updateData({'recommend.$userId': false});
    DbRefs.timelineRef
        .document(postId)
        .updateData({'forbidden.$userId': false});

    // delete Reaction To Activity Feed of other user.
    deleteReactionToActivityFeed(
        currentUserId: currentUser.uid, authorId: authorId, postId: postId);

    setState(() {
      isPressed = false;
      forbiddenCount -= 1;
      ameenCount -= 1;
      recommendCount -= 1;
      forbiddenReaction[userId] = false;
      ameenReaction[userId] = false;
      recommendReaction[userId] = false;
    });
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

  Widget _overlayReactionButtons() {
    List<ReactiveIconDefinition> _reactionsList = <ReactiveIconDefinition>[
      ReactiveIconDefinition(
          assetIcon: AppImages.coloredPrayIcon,
          code: AppImages.coloredPrayIcon),
      ReactiveIconDefinition(
        assetIcon: AppImages.coloredRecommendIcon,
        code: AppImages.coloredRecommendIcon,
      ),
      ReactiveIconDefinition(
        assetIcon: AppImages.coloredForbiddenIcon,
        code: AppImages.coloredForbiddenIcon,
      ),
    ];

    return ReactiveButton(
      containerAbove: true,
      iconWidth: 35.0,
      containerPadding: 0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 0.2,
                spreadRadius: 0.2,
                offset: Offset(1, 1))
          ]),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: ReactionsButtonRow(
            image: icons == null
                ? Image.asset(AppImages.blackPrayIcon)
                : Image.asset(
                    icons.toString(),
                    width: 20.0,
                    height: 20.0,
                  ),
            label: (() {
              if (icons == AppImages.blackPrayIcon) {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              } else if (icons == AppImages.coloredPrayIcon) {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              } else if (icons == AppImages.coloredRecommendIcon) {
                return Text(AppLocalizations.of(context).recommend,
                    style: btnStyle);
              } else if (icons == AppImages.coloredForbiddenIcon) {
                return LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * 0.2,
                    child: Text(AppLocalizations.of(context).beware,
                        style: btnStyle, overflow: TextOverflow.fade));
              } else {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              }
            }()),
          ),
        ),
      ),
      icons: _reactionsList, //_flags,
      onTap: () {
        bool ameenPressed = ameenReaction[userId] == true;
        bool forbiddenPressed = forbiddenReaction[userId] == true;
        bool recommendPressed = recommendReaction[userId] == true;

        setState(() {
          if (ameenPressed || forbiddenPressed || recommendPressed) {
            deleteAllReactions();
            icons = AppImages.blackPrayIcon;
          } else if (!ameenPressed && !forbiddenPressed && !recommendPressed) {
            handleAmeenReact();
            icons = AppImages.coloredPrayIcon;
          }
        });
      },
      onSelected: (ReactiveIconDefinition button) {
        setState(() {
          icons = button.code;

          // If Ameen Clicked!
          if (icons == AppImages.coloredPrayIcon) {
            deleteAllReactions();
            handleAmeenReact();
            icons = AppImages.coloredPrayIcon;
          }

          // If Recommend Clicked!
          else if (icons == AppImages.coloredRecommendIcon) {
            deleteAllReactions();
            handleRecommendReact();

            icons = AppImages.coloredRecommendIcon;
          }

          // If Forbidden Clicked!
          else if (icons == AppImages.coloredForbiddenIcon) {
            deleteAllReactions();
            handleForbiddenReact();
            icons = AppImages.coloredForbiddenIcon;
          }
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
