import 'package:ameen/helpers/ad_manager.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:ameen/ui/widgets/comment/add_new_comment.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; //for date locale
import 'package:ameen/helpers/ui/images.dart' as myImages;
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:intl/intl.dart';

// This class represent the UI of Post and every thing related with it..
class PostWidget extends StatefulWidget {
  PostData postModel;
  String postId;
  String postBody;
  String authorName;
  String authorId;
  String authorPhoto;
  int ameenCount;
  int forbiddenCount;
  int recommendCount;
  Timestamp postTime;
  dynamic ameenReaction;
  dynamic recommendReaction;
  dynamic forbiddenReaction;

  PostWidget({
    Key key,
    this.postId,
    this.postBody,
    this.authorId,
    this.ameenCount,
    this.forbiddenCount,
    this.recommendCount,
    this.ameenReaction,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.recommendReaction,
    this.forbiddenReaction,
  }) : super(key: key);

  factory PostWidget.fromDocument(DocumentSnapshot doc) {
    return PostWidget(
      postId: doc['postId'],
      postBody: doc['postBody'],
      authorName: doc['username'],
      authorId: doc['userId'],
      ameenReaction: doc['ameen'],
      recommendReaction: doc['recommend'],
      forbiddenReaction: doc['forbidden'],
      postTime: doc['created_at'],
      authorPhoto: doc['profilePicture'],
    );
  }

  factory PostWidget.fromQuery(QuerySnapshot doc) {
    return PostWidget(
      postId: 'postId',
      postBody: 'postBody',
      authorName: 'username',
      authorId: 'userId',
      ameenReaction: 'ameen',
      recommendReaction: 'recommend',
      forbiddenReaction: 'forbidden',
      postTime: Timestamp.now(),
      authorPhoto: 'profilePicture',
    );
  }

  int getAmeenCount(ameen) {
    // if no likes, return 0
    if (ameenReaction == null &&
        recommendReaction == null &&
        forbiddenReaction == null) {
      return 0;
    }
    int count = 0;
    ameenReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getForbiddenCount(forbidden) {
    // if no likes, return 0
    if (ameenReaction == null &&
        recommendReaction == null &&
        forbiddenReaction == null) {
      return 0;
    }

    int count = 0;
    forbiddenReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getTotalCount(ameen, recommend, forbidden) {
    // if no likes, return 0
    if (ameenReaction == null &&
        recommendReaction == null &&
        forbiddenReaction == null) {
      return 0;
    }
    int count = 0;
    ameenReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    forbiddenReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    recommendReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getRecommendCount(recommend) {
    // if no likes, return 0
    if (recommendReaction == null) {
      return 0;
    }
    int count = 0;
    recommendReaction.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostWidgetState createState() => _PostWidgetState(
        postModel: this.postModel,
        postId: this.postId,
        authorId: this.authorId,
        authorName: this.authorName,
        authorPhoto: this.authorPhoto,
        postBody: this.postBody,
        postTime: this.postTime,
        ameenReaction: this.ameenReaction,
        recommendReaction: this.recommendReaction,
        forbiddenReaction: this.forbiddenReaction,
        ameenCount: getAmeenCount(this.ameenReaction),
        recommendCount: getRecommendCount(this.recommendReaction),
        forbiddenCount: getForbiddenCount(this.forbiddenReaction),
      );
}

class _PostWidgetState extends State<PostWidget> {
  _PostWidgetState(
      {Key key,
      this.postId,
      this.postBody,
      this.postTime,
      this.ameenCount,
      this.recommendCount,
      this.forbiddenCount,
      this.authorId,
      this.authorName,
      this.authorPhoto,
      this.ameenReaction,
      this.recommendReaction,
      this.forbiddenReaction,
      this.postModel});

  CollectionReference usersRef =
      Firestore.instance.collection(DatabaseTable.users);
  CollectionReference postsRef =
      Firestore.instance.collection(DatabaseTable.posts);
  CollectionReference commentsRef =
      Firestore.instance.collection(DatabaseTable.comments);

  String postId;
  String postBody;
  String authorName;
  String authorId;
  String authorPhoto;
  Timestamp postTime;

  int ameenCount;
  int recommendCount;
  int forbiddenCount;
  int commentsCount;
  Map ameenReaction;
  Map recommendReaction;
  Map forbiddenReaction;
  int counterOfComments;
  int totalReactions;
  PostData postModel;

  dynamic _postData;
  String currentLang = Intl.getCurrentLocale();
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    _getPostData();
    _isInterstitialAdReady = false;
    _interstitialAd = createInterstitialAd();
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        pushPage(
            context,
            PostPage(
              postId: postId,
              authorId: authorId,
              authorName: authorName,
              postModel: postModel,
            ));
        break;
      case MobileAdEvent.closed:
        pushPage(
            context,
            PostPage(
              postId: postId,
              authorId: authorId,
              authorName: authorName,
              postModel: postModel,
            ));
        break;
      default:
      // do nothing
    }
  }

  // Get Post Data
  _getPostData() {
    _postData = getPostData(
        postsRef: DbRefs.postsRef,
        postId: widget.postId,
        userId: widget.authorId);
    _postData.then((doc) {
      setState(() {
        postModel = PostData.fromDocument(doc);
      });
    });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  _deletePost() async {
    // delete post itself
    postsRef
        .document(authorId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete post itself
    DbRefs.timelineRef.document(postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await DbRefs.activityFeedRef
        .document(authorId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 0.5, // has the effect of softening the shadow
            offset: new Offset(0.5, 0.5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: FutureBuilder(
        future: usersRef.document(authorId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
              ),
              _headOfPost(),
              Container(
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          createInterstitialAd()
                            ..load()
                            ..show();
                        },
                        child: _postBody()),
                    InkWell(
                        onTap: () {
                          createInterstitialAd()
                            ..load()
                            ..show();
                        },
                        child: _reactAndCommentCounter()),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              ReactionsButtons(
                authorId: authorId,
                postId: postId,
                postBody: postBody,
                ameenCount: ameenCount,
                ameenReaction: ameenReaction,
                forbiddenReaction: forbiddenReaction,
                recommendReaction: recommendReaction,
                forbiddenCount: forbiddenCount,
                recommendCount: recommendCount,
              ),
              InkWell(
                  onTap: () {
                    createInterstitialAd()
                      ..load()
                      ..show();
                  },
                  child: AddNewCommentWidget(
                    authorPhoto: authorPhoto,
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _postBody() {
    return InkWell(
      onTap: () => pushPage(
          context,
          PostPage(
            postId: postId,
            authorId: authorId,
            authorName: authorName,
            postModel: postModel,
          )),
      child: Container(
        alignment: currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
        margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 0),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          postBody,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontFamily: 'Dubai',
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // The top Section of Post (Photo, Time, Settings, Name)
  Widget _headOfPost() {
    bool isPostOwner = currentUser.uid == authorId;

    // To handle function of selected Item in PopupMenuButton
    void choiceAction(String option) async {
      if (option == AppLocalizations.of(context).deletePost) {
        _handleDeletePost(context);
      } else if (option == AppLocalizations.of(context).savePost) {
        //TODO => Handle it Later to Save Post.
        print('Button Clicked');
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Show Name of the author, Time of post and Image of User
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                pushPage(context,
                    UserProfile(profileId: authorId, currentUser: currentUser));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 22.0,
                  backgroundImage: authorPhoto == null
                      ? AssetImage(AppImages.AnonymousPerson)
                      : CachedNetworkImageProvider(authorPhoto),
                ),
              ),
            ),
            Column(
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: currentLang == 'ar'
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.baseline,
              children: <Widget>[
                // Name of the user
                Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
                  child: Text(
                    authorName.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 15,
                    ),
                  ),
                ),

                // Time of the post
                Container(child: _postTimeStamp()),
              ],
            ),
          ],
        ),

        // Show Popup More Button
        Flexible(
          // More button to show options of post.
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: choiceAction,
            itemBuilder: (context) => [
              /// Remove Post Item
              PopupMenuItem(
                // Check if the post is belong to the current User or not .. to show or remove (Remove Post)
                child: Visibility(
                    visible: isPostOwner ? true : false,
                    child: Text(AppLocalizations.of(context).deletePost)),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: isPostOwner ? 30 : 0,
                value: AppLocalizations.of(context).deletePost,
              ),

              /// Save Post Item
              PopupMenuItem(
                child: Text(AppLocalizations.of(context).savePost),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: 30,
                value: AppLocalizations.of(context).savePost,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Time of post created..
  Widget _postTimeStamp() {
    initializeDateFormatting();
    var timestamp = postTime.toDate();
    var date = DateFormat.yMMMd().add_jm().format(timestamp);

    var timeTheme = new TextStyle(
        fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

//    initializeDateFormatting('ar');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Text(
        date.toString(),
        style: timeTheme,
        textAlign: TextAlign.end,
      ),
    );
  }

  // React counter
  Widget _reactAndCommentCounter() {
    return Visibility(
      child: Container(
        height: 30,
        width: double.maxFinite,
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container of Numbers and Reactions Icons
            _counterOfReactions(),

            // Counter of Comments (Numbers)
            _counterOfComment(),
          ],
        ),
      ),
    );
  }

  // Counter of Comments (Numbers)
  _counterOfComment() {
    return StreamBuilder(
        stream: commentsRef
            .document(widget.postId)
            .collection(DatabaseTable.comments)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(width: 0, height: 0);
          }
          if (snapshot.connectionState == ConnectionState.active) {
            final counterOfComments = snapshot.data.documents.length;
            return Visibility(
                visible: counterOfComments != null && counterOfComments >= 1
                    ? true
                    : false,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      // Number of comments
                      Text(
                          counterOfComments == null
                              ? ''
                              : counterOfComments.toString(),
                          style: mytextStyle.reactCounterTextStyle),
                      Padding(padding: EdgeInsets.only(right: 2, left: 3)),
                      // "Comment Word"
                      Text(AppLocalizations.of(context).comment,
                          style: mytextStyle.reactCounterTextStyle),
                    ],
                  ),
                ));
          }
          return Container(width: 0, height: 0);
        });
  }

  // Container of Numbers and Reactions Icons
  _counterOfReactions() {
    // Container of Numbers and Reactions Icons
    return StreamBuilder(
        stream: postsRef
            .document(authorId)
            .collection('userPosts')
            .document(postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            dynamic amenSnapshot = snapshot.data['ameen'];
            dynamic recommendSnapshot = snapshot.data['recommend'];
            dynamic forbiddenSnapshot = snapshot.data['forbidden'];

            int counterOfAmeen = widget.getAmeenCount(amenSnapshot);
            int counterOfForbidden =
                widget.getForbiddenCount(forbiddenSnapshot);
            int counterOfRecommend =
                widget.getRecommendCount(recommendSnapshot);

            totalReactions =
                counterOfAmeen + counterOfRecommend + counterOfForbidden;
            return Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: (counterOfAmeen >= 1 ||
                      counterOfRecommend >= 1 ||
                      counterOfForbidden >= 1)
                  ? true
                  : false,
              child: Container(
                margin: EdgeInsets.only(right: 5, left: 5),
                child: Row(
                  children: <Widget>[
                    // Counter of Reaction (Numbers)
                    Container(
                      margin: EdgeInsets.only(right: 2, left: 2),
                      child: Text(
                        //Check if the Total Reactions = 0 or not
                        totalReactions >= 1 ? totalReactions.toString() : '',
                        style: mytextStyle.reactCounterTextStyle,
                      ),
                    ),

                    // Counter of Reaction (Icons)
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Ameen React
                          Visibility(
                            visible: counterOfAmeen >= 1 ? true : false,
                            child: myImages.ameenIconReactCounter,
                          ),

                          // Recommend React
                          Visibility(
                            visible: counterOfRecommend >= 1 ? true : false,
                            child: myImages.recommendIconReactCounter,
                          ),

                          // Forbidden React
                          Visibility(
                            visible: counterOfForbidden >= 1 ? true : false,
                            child: myImages.forbiddenIconReactCounter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }

  _handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("هل تريد حذف المنشور"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    _deletePost();
                  },
                  child: Text(
                    AppLocalizations.of(context).yes,
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context).cancel)),
            ],
          );
        });
  }
}
