import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/comment.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ameen/services/connection_check.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/widgets/comment/comment_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:ameen/helpers/ui/images.dart' as myImages;
import 'package:timeago/timeago.dart' as timeago;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toast/toast.dart';

class PostPage extends StatefulWidget {
  String postId;
  String authorId;
  String authorName;

  PostPage({
      this.postId,
      this.authorId,
      this.authorName,
  });

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<AnimatedListState> listOfComment = GlobalKey();
  CommentModel commentModel;
  PostData postModel;
  UserModel user;
  int ameenCount;
  int recommendCount;
  int forbiddenCount;
  int commentsCount;

  String errorMessage;
  dynamic data, userData;

  bool _isLoading = false;
  var logger = Logger();

  String currentLang = Intl.getCurrentLocale();

  @override
  void initState() {
    super.initState();
    _getPostData();
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
  }

  // Get user data
  _getUserData() {
    userData = getCurrentUserData(userId: currentUser.uid);
    userData.then((doc) => setState(() {
          user = UserModel.fromDocument(doc);
          print(user.uid);
        }));
  }

  _deletePost() async {
    // delete post itself
    postsRef
        .document(widget.authorId)
        .collection('userPosts')
        .document(widget.postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete post itself
    DbRefs.timelineRef.document(widget.postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await DbRefs.activityFeedRef
        .document(widget.authorId)
        .collection("feedItems")
        .where('postId', isEqualTo: widget.postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(widget.postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  // Get Post Data
  _getPostData() {
    data = getPostData(
        postsRef: DbRefs.postsRef, postId: widget.postId, userId: widget.authorId);
    data.then((doc) {
      setState(() {
        postModel = PostData.fromDocument(doc);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cBackground,
      appBar: AppBar(
        title: _isLoading
            ? Text('')
            : Text(
                //Put the name of the author's post on the Appbar
                widget.authorName ??= '',
                style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Dubai',
                    fontWeight: FontWeight.w700,
                    color: AppColors.cBackground)),
        leading: IconButton(
          icon: ImageIcon(AssetImage(AppImages.arrowBack)),
          iconSize: 18,
          onPressed: () {
            Navigator.of(context).pop(NewsFeed);
          },
          disabledColor: AppColors.cBackground,
        ),
      ),
      body: FutureBuilder(
          future: getPostData(
              postsRef: DbRefs.postsRef,
              postId: widget.postId,
              userId: widget.authorId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ShimmerWidget(
                shimmerCount: 1,
              );
            }
            postModel = PostData.fromDocument(snapshot.data);
            if (_isLoading) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: AppColors.cBackground,
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.cGreen),
              ));
            }
            return RefreshIndicator(
              color: AppColors.cGreen,
              backgroundColor: Colors.white,
              onRefresh: () async {
                _getPostData();
              },
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white10,
                            blurRadius:
                                0.1, // has the effect of softening the shadow
                            offset: new Offset(0.1, 0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13)),

                          // The top Section of Post (Photo, Time, Settings, Name)
                          _headOfPost(),

                          // The post of the Post
                          _postBody(),

                          // React and Comment Counter
                          _reactAndCommentCounter(),

                          // The Beginning of Reaction Buttons Row
                          SizedBox(height: 12),

                          ReactionsButtons(
                            ameenReaction: postModel.ameenReaction,
                            ameenCount: ameenCount,
                            authorId: widget.authorId,
                            postId: widget.postId,
                            postBody: postModel.body,
                            recommendReaction: postModel.recommendReaction,
                            forbiddenReaction: postModel.forbiddenReaction,
                            forbiddenCount: forbiddenCount,
                            recommendCount: recommendCount,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    // List of a comments
                    Expanded(child: _listOfComment()),

                    // Write a Comment Widget
                    _writeAComment(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _postBody() {
    return Container(
      alignment: currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
      margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 0),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        postModel.body,
        style: TextStyle(
          textBaseline: TextBaseline.alphabetic,
          fontFamily: 'Dubai',
          fontSize: 15,
        ),
      ),
    );
  }

  // The top Section of Post (Photo, Time, Settings, Name)
  Widget _headOfPost() {
    bool isPostOwner = currentUser.uid == widget.authorId;

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
                    UserProfile(profileId: widget.authorId, currentUser: currentUser));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 22.0,
                  backgroundImage: postModel.authorPhoto == null
                      ? AssetImage(AppImages.AnonymousPerson)
                      : CachedNetworkImageProvider(postModel.authorPhoto),
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
                    widget.authorName.toString(),
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
    var timestamp = postModel.postTime.toDate();
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
    return Container(
      height: 30,
      width: double.maxFinite,
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Container of Numbers and Reactions Icons
          StreamBuilder(
              stream: postsRef
                  .document(widget.authorId)
                  .collection('userPosts')
                  .document(widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  dynamic amenSnapshot = snapshot?.data['ameen'];
                  dynamic recommendSnapshot = snapshot?.data['recommend'];
                  dynamic forbiddenSnapshot = snapshot?.data['forbidden'];

                  int counterOfAmeen = postModel.getAmeenCount(amenSnapshot);
                  int counterOfForbidden =
                  postModel.getForbiddenCount(forbiddenSnapshot);
                  int counterOfRecommend =
                  postModel.getRecommendCount(recommendSnapshot);

                  int totalReactions =
                      counterOfAmeen + counterOfForbidden + counterOfRecommend;
                  return Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: (counterOfAmeen >= 1 || counterOfForbidden >= 1 || counterOfRecommend >= 1)
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
                              totalReactions >= 1
                                  ? totalReactions.toString()
                                  : '',
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
                                  visible:
                                  counterOfRecommend >= 1 ? true : false,
                                  child: myImages.recommendIconReactCounter,
                                ),

                                // Forbidden React
                                Visibility(
                                  visible:
                                  counterOfForbidden >= 1 ? true : false,
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
              }),

          // Counter of Comments (Numbers)
          StreamBuilder(
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
                      visible:
                      counterOfComments != null && counterOfComments >= 1
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
                            Padding(
                                padding: EdgeInsets.only(right: 2, left: 3)),
                            // "Comment Word"
                            Text(AppLocalizations.of(context).comment,
                                style: mytextStyle.reactCounterTextStyle),
                          ],
                        ),
                      ));
                }
                return Container(width: 0, height: 0);
              }),
        ],
      ),
    );
  }


  // Add a Comment Widget
  Widget _writeAComment() {
    TextEditingController _text = new TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1, color: Colors.grey.shade500),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1.0),
            blurRadius: 1.3, // has the effect of softening the shadow
            offset: new Offset(1.0, 1.0),
          ),
        ],
      ),
      height: 55,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
            color: AppColors.cBackground,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Submit Icon Button to Add Comment to List..
            IconButton(
                iconSize: 24,
                disabledColor: AppColors.cGreen,
                icon: ImageIcon(AssetImage(AppImages.sendBtn),
                    color: AppColors.cGreen, size: 20),
                onPressed: () async {
                  // Check if Text Field is Empty or not..
                  if (_text.text.isEmpty) {
                    Toast.show(
                      AppLocalizations.of(context).commentIsEmpty,
                      context,
                      backgroundColor: Colors.red.shade700,
                      textColor: Colors.white,
                      gravity: Toast.BOTTOM,
                      duration: Toast.LENGTH_SHORT,
                    );
                  } else {
                    // Check Internet Connection..
                    ConnectivityCheck();
                    DbRefs.commentsRef
                        .document(postModel.postId)
                        .collection("comments")
                        .add({
                      "username": user.username,
                      "comment": _text.text,
                      "created_at": DateTime.now(),
                      "authorPhoto": user.profilePicture,
                      "userId": currentUser.uid,
                    });

                    bool isNotPostOwner = widget.postId != currentUser.uid;
                    if (isNotPostOwner) {
                      DbRefs.activityFeedRef
                          .document(postModel.authorId)
                          .collection('feedItems')
                          .add({
                        'type': 'comment',
                        'commentBody': _text.text,
                        'username': user.username,
                        'userId': currentUser.uid,
                        'profilePicture': user.profilePicture,
                        'postId': widget.postId,
                        'created_at': DateTime.now()
                      });
                    }

                    // Clear the text after Comment Added..
                    _text.clear();
                  }
                }),

            // Text Field(Input) of Comment..
            Expanded(
              child: TextField(
                maxLines: 20,
                dragStartBehavior: DragStartBehavior.down,
                textAlign: TextAlign.right,
                showCursor: true,
                cursorColor: AppColors.cGreenDark,
                controller: _text,
                scrollPhysics: ScrollPhysics(),
                enabled: true,
                scrollController: ScrollController(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).writeAComment,
                  hintStyle: TextStyle(
                    fontFamily: 'Dubai',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List Of Comment
  Widget _listOfComment() {
    return StreamBuilder(
        stream: DbRefs.commentsRef
            .document(postModel.postId)
            .collection(DatabaseTable.comments)
            .orderBy("created_at", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ShimmerWidget();
          }

          List<CommentWidget> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(CommentWidget.fromDocument(doc));
          });

          return ListView(
            children: comments,
          );
        });
  }
}
