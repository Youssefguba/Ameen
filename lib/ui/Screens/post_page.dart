import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/models/comment.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/models/reaction_model.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/widgets/comment/comment_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String postId;
  final String authorId;
  String authorName;
  PostPage({this.postId, this.authorId, this.authorName});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  CollectionReference postsRef = Firestore.instance.collection(DatabaseTable.posts);
  CollectionReference commentsRef = Firestore.instance.collection(DatabaseTable.comments);
  CollectionReference activityFeedRef = Firestore.instance.collection(DatabaseTable.feeds);

  final GlobalKey<AnimatedListState> listOfComment = GlobalKey();
  CommentModel commentModel;
  PostData postModel;
  UserModel user;
  int ameenCount;
  int commentsCount;

  String errorMessage;
  dynamic data, userData;

  bool _isLoading = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getPostData();
    _getTotalOfComments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Get the number of total Comments
  _getTotalOfComments() {
    commentsRef
        .document(widget.postId)
        .collection(DatabaseTable.comments)
        .getDocuments()
        .then((data) {
      setState(() {
        commentsCount = data.documents.length;
      });
    });
  }

  // Get user data
  _getUserData() {
    userData = getCurrentUserData(usersRef: usersRef, userId: currentUser.uid);
    userData.then((doc) => setState(() => user = UserModel.fromDocument(doc)));
  }

  // Get Post Data
  _getPostData() {
    data = getPostData(
        postsRef: postsRef,
        postId: widget.postId,
        currentUserId: currentUser.uid);
    data.then((doc) {
      setState(() {
        postModel = PostData.fromDocument(doc);
        ameenCount = postModel.getAmeenCount(postModel.ameenReaction);
      });
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
          icon: ImageIcon(AssetImage(AppIcons.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop(NewsFeed);
          },
          disabledColor: AppColors.cBackground,
        ),
      ),
      body: FutureBuilder(
          future: getPostData(
              postsRef: postsRef,
              postId: widget.postId,
              currentUserId: currentUser.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return RefreshProgress();
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
              onRefresh: () async {},
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
                            postId: postModel.postId,
                            ameenReaction: postModel.ameenReaction,
                            authorId: postModel.authorId,
                            ameenCount: ameenCount,
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

//      bottomNavigationBar:
//            AddNewPostWidget("أكتب تعليقا ...", Colors.grey[300]),
    );
  }

  // The  Body of the Post
  Widget _postBody() {
    return Container(
      alignment: AlignmentDirectional.topEnd,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Text(
        postModel.body,
        style: TextStyle(
          fontFamily: 'Dubai',
          fontSize: 15,
        ),
      ),
    );
  }

  // The top Section of Post (Photo, Time, Settings, Name)
  Widget _headOfPost() {
    const String removePost = 'حذف المنشور';
    const String savePost = "حفظ المنشور في القائمة";

    // To handle function of selected Item in PopupMenuButton
    void choiceAction(String option) async {
      if (option == removePost) {
      } else if (option == savePost) {
        //TODO => Handle it Later to Save Post.
        print('Button Clicked');
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
                child: Visibility(visible: true, child: Text(removePost)),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: 30,
                value: removePost,
              ),

              /// Save Post Item
              PopupMenuItem(
                child: Text(savePost),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: 30,
                value: savePost,
              ),
            ],
          ),
        ),

        // Show Name of the author, Time of post and Image of User
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
                  child: Text(
                    postModel.authorName,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 15,
                    ),
                  ),
                ),
                _postTimeStamp(),
              ],
            ),
            Container(
              width: 45,
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.0,
                backgroundImage: postModel.authorPhoto == null
                    ? AssetImage(AppIcons.AnonymousPerson)
                    : CachedNetworkImageProvider(postModel.authorPhoto),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Time of post created..
  Widget _postTimeStamp() {
    initializeDateFormatting('ar');
    var timestamp = postModel.postTime.toDate();
    var date = DateFormat.yMMMd('ar').add_jm().format(timestamp);

    var timeTheme = new TextStyle(
        fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(timeago.format(timestamp, locale: 'ar'), style: timeTheme),
    );
  }

  // React counter
  Widget _reactAndCommentCounter() {
    return Container(
      height: 20,
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Counter of Comments (Numbers)
          Visibility(
              visible: commentsCount >= 1 ? true : false,
              child: Container(
                child: Row(
                  children: <Widget>[
                    // "Comment Word"
                    Text('تعليق', style: mytextStyle.reactCounterTextStyle),

                    // Number of comments
                    Text(commentsCount.toString(),
                        style: mytextStyle.reactCounterTextStyle),
                  ],
                ),
              )),

          // Container of Numbers and Reactions Icons
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: ameenCount >= 1 ? true : false,
            child: Container(
              margin: EdgeInsets.only(right: 5, left: 5),
              child: Row(
                children: <Widget>[
                  // Counter of Reaction (Numbers)
                  Container(
                    margin: EdgeInsets.only(right: 2, left: 2),
                    child: Text(
                      //Check if the Total Reactions = 0 or not
                      ameenCount >= 1 ? ameenCount.toString() : '',
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
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: ameenCount >= 1 ? true : false,
                          child: myImages.ameenIconReactCounter,
                        ),

                        // Recommend React
                        Visibility(
                          visible: false,
                          child: myImages.recommendIconReactCounter,
                        ),

                        // Forbidden React
                        Visibility(
                          visible: false,
                          child: myImages.forbiddenIconReactCounter,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                icon: ImageIcon(AssetImage(AppIcons.sendBtn),
                    color: AppColors.cGreen, size: 20),
                onPressed: () async {
                  // Check if Text Field is Empty or not..
                  if (_text.text.isEmpty) {
                    Toast.show(
                      "التعليق ليس به أي محتوى",
                      context,
                      backgroundColor: Colors.red.shade700,
                      textColor: Colors.white,
                      gravity: Toast.BOTTOM,
                      duration: Toast.LENGTH_SHORT,
                    );
                  } else {
                    // Check Internet Connection..
                    ConnectivityCheck();
                    commentsRef
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
                    if  (isNotPostOwner) {
                      activityFeedRef.document(postModel.authorId).collection('feedItems')
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
                  hintText: " ... أكتب تعليق ",
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
        stream: commentsRef
            .document(postModel.postId)
            .collection(DatabaseTable.comments)
            .orderBy("created_at", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return RefreshProgress();
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

