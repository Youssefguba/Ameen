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
    );
  }
}

class OverlayReactions extends StatelessWidget {
  final Widget image;
  final String label;
  OverlayReactions({this.image, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
          ),
          Container(width: 20, height: 20, child: image),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
            child: Text(label,
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: AppColors.cTextColor,
                )),
          ),
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
    userIsReaction();
    initAmeenBtn();
  }

  userIsReaction() {
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

      addAmenReactionToActivityFeed();

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

      deleteAmenReactionToActivityFeed();
      setState(() {
        isPressed = ameenReaction[userId] == false;
        ameenCount -= 1;
        ameenReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

  void addAmenReactionToActivityFeed() {
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

  void deleteAmenReactionToActivityFeed() {
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

      addAmenReactionToActivityFeed();

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

      deleteAmenReactionToActivityFeed();
      setState(() {
        isPressed = recommendReaction[userId] == false;
        recommendCount -= 1;
        recommendReaction[userId] = false;
        animControlBtnShortPress.reverse();
      });
    }
  }

//  void addReactionToActivityFeed() {
//    bool isNotPostOwner = currentUser.uid != authorId;
//    if (isNotPostOwner) {
//      DbRefs.activityFeedRef
//          .document(authorId)
//          .collection('feedItems')
//          .document(postId)
//          .setData({
//        'type': 'amen',
//        'username': user.username,
//        'userId': userId,
//        'profilePicture': user.profilePicture,
//        'postId': postId,
//        'created_at': DateTime.now()
//      });
//    }
//  }
//
//  void deleteReactionToActivityFeed() {
//    bool isNotPostOwner = currentUser.uid != authorId;
//    if (isNotPostOwner) {
//      DbRefs.activityFeedRef
//          .document(authorId)
//          .collection('feedItems')
//          .document(postId)
//          .get()
//          .then((doc) {
//        if (doc.exists) {
//          doc.reference.delete();
//        }
//      });
//    }
//  }

//  void handleAmeenReact() {
//    isPressed = ameenReaction[userId] == true;
//    if (!isPressed) {
//      // Update data in user profile
//      DbRefs.postsRef
//          .document(authorId)
//          .collection(DatabaseTable.userPosts)
//          .document(postId)
//          .updateData({'ameen.$userId': true});
//
//      // Update data in timeline
//      DbRefs.timelineRef.document(postId).updateData({'ameen.$userId': true});
//
//      addReactionToActivityFeed();
//
//      setState(() {
//        isPressed = true;
//        ameenCount += 1;
//        ameenReaction[userId] = true;
//        animControlBtnShortPress.forward();
//      });
//    } else if (isPressed) {
//      // Update data in user profile
//      DbRefs.postsRef
//          .document(authorId)
//          .collection(DatabaseTable.userPosts)
//          .document(postId)
//          .updateData({'ameen.$userId': false});
//
//      // Update data in timeline
//      DbRefs.timelineRef.document(postId).updateData({'ameen.$userId': false});
//
//      deleteReactionToActivityFeed();
//      setState(() {
//        isPressed = false;
//        ameenCount -= 1;
//        ameenReaction[userId] = false;
//        animControlBtnShortPress.reverse();
//      });
//    }
//  }
//
//  void addReactionToActivityFeed() {
//    bool isNotPostOwner = currentUser.uid != authorId;
//    if (isNotPostOwner) {
//      DbRefs.activityFeedRef
//          .document(authorId)
//          .collection('feedItems')
//          .document(postId)
//          .setData({
//        'type': 'amen',
//        'username': user.username,
//        'userId': userId,
//        'profilePicture': user.profilePicture,
//        'postId': postId,
//        'created_at': DateTime.now()
//      });
//    }
//  }
//
//  void deleteReactionToActivityFeed() {
//    bool isNotPostOwner = currentUser.uid != authorId;
//    if (isNotPostOwner) {
//      DbRefs.activityFeedRef
//          .document(authorId)
//          .collection('feedItems')
//          .document(postId)
//          .get()
//          .then((doc) {
//        if (doc.exists) {
//          doc.reference.delete();
//        }
//      });
//    }
//  }

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

//  Widget _overlayReactionButtons() {
//    return FlutterReactionButtonCheck(
//      boxColor: Colors.white,
//      boxRadius: 20,
//      boxDuration: Duration(milliseconds: 300),
//      boxElevation: 5.0,
//      boxPosition: Position.BOTTOM,
//      highlightColor: Colors.black,
//
//      onReactionChanged: (reaction, isChecked) {
//        if(reaction.id == 1 ){
//          handleAmeenReact();
//        }
//        else if (reaction.id == 2 ) {
//          handleRecommendReact();
//        }
//      },
//      reactions: <Reaction>[
//        Reaction(
//            id: 1,
//            previewIcon: OverlayReactions(
//              image: Image.asset(AppImages.coloredPrayIcon),
//              label: AppLocalizations.of(context).amen,
//            ),
//            icon:  ReactionsButtonRow(
//              image: Image.asset(AppImages.coloredPrayIcon),
//              label: AppLocalizations.of(context).amen,
//            )),
//        Reaction(
//            id: 2,
//            previewIcon: OverlayReactions(
//              image: Image.asset(AppImages.coloredRecommendIcon),
//              label: AppLocalizations.of(context).amen,
//            ),
//            icon: ReactionsButtonRow(
//              image: Image.asset(AppImages.coloredRecommendIcon),
//              label: AppLocalizations.of(context).amen,
//            )),
//        Reaction(
//            id: 3,
//            previewIcon: OverlayReactions(
//              image: Image.asset(AppImages.coloredForbiddenIcon),
//              label: AppLocalizations.of(context).amen,
//            ),
//            icon: ReactionsButtonRow(
//              image: Image.asset(AppImages.coloredForbiddenIcon),
//              label: AppLocalizations.of(context).amen,
//            )),
//      ],
//
//      initialReaction:
//          Reaction(
//            id: 0, icon: ReactionsButtonRow(
//            image: (() {
//              if (ameenReaction[userId] == true) {
//                return Image.asset(AppImages.coloredPrayIcon);
//              } else if (recommendReaction[userId] == true) {
//                return Image.asset(AppImages.coloredRecommendIcon);
//              } else if (forbiddenReaction[userId] == true) {
//                return Image.asset(AppImages.coloredForbiddenIcon);
//              }
//              return Image.asset(AppImages.blackPrayIcon);
//            }()),
//            label: AppLocalizations.of(context).amen,
//          )),
//      selectedReaction: Reaction(id: 0, icon: Image.asset(AppImages.blackPrayIcon, width: 20, height: 20)),
//    );
//  }

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
      roundIcons: true,
      containerAbove: true,
      iconWidth: 32.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 0.2,
                spreadRadius: -0.2,
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
              if(icons == AppImages.blackPrayIcon) {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              } else if (icons == AppImages.coloredPrayIcon) {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              } else if (icons == AppImages.coloredRecommendIcon) {
                return Text('أرشحه للجميع', style: btnStyle);
              }
              else {
                return Text(AppLocalizations.of(context).amen, style: btnStyle);
              }
            } ()),
          ),
        ),
      ),
      icons: _reactionsList, //_flags,
      onTap: () {
        print('TAP');
        setState(() {
          // If Recommend = True and others false..
          if (recommendReaction[userId] == true &&
              ameenReaction[userId] == false &&
              icons == AppImages.coloredRecommendIcon) {
            icons = AppImages.blackPrayIcon;
            handleRecommendReact();
            print('TAP 1 ');

            // If Amen = True and others false ..
          } else if (ameenReaction[userId] == true &&
              icons == AppImages.coloredPrayIcon &&
              recommendReaction[userId] == false) {
            icons = AppImages.blackPrayIcon;
            handleAmeenReact();
            print('TAP 2 ');
          } else if (recommendReaction[userId] == false &&
              ameenReaction[userId] == false) {
            icons = AppImages.coloredPrayIcon;
            handleAmeenReact();
            print('TAP 4');
          }
        });
      },
      onSelected: (ReactiveIconDefinition button) {
        setState(() {
          icons = button.code;
          if (ameenReaction[userId] == false &&
              icons == AppImages.coloredPrayIcon) {
            handleAmeenReact();
            icons = AppImages.coloredPrayIcon;
          } else if (recommendReaction[userId] == false &&
              icons == AppImages.coloredRecommendIcon) {
            handleRecommendReact();
            icons = AppImages.coloredRecommendIcon;
          } else if (recommendReaction[userId] == true &&
              icons == AppImages.coloredRecommendIcon) {
            handleRecommendReact();
            icons = AppImages.blackPrayIcon;
          } else if (ameenReaction[userId] == true &&
              icons == AppImages.coloredPrayIcon) {
            handleAmeenReact();
            icons = AppImages.blackPrayIcon;
          }
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
