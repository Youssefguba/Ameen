import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/models/comment.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/ui/widgets/comment/add_new_comment.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; //for date locale
import 'package:ameen/helpers/ui/images.dart' as myImages;
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:intl/intl.dart';

// This class represent the UI of Post and every thing related with it..
class PostWidget extends StatefulWidget  {
  UserModel userModel;
  String postId;
  String postBody;
  String authorName;
  String authorId;
  String authorPhoto;
  int ameenCount;
  Timestamp postTime;
  dynamic ameenReaction;

  PostWidget(
      {Key key,
      this.userModel,
      this.postId,
      this.postBody,
      this.authorId,
      this.ameenCount,
      this.ameenReaction,
      this.authorName,
      this.authorPhoto,
      this.postTime})
      : super(key: key);

  factory PostWidget.fromDocument(DocumentSnapshot doc) {
    return PostWidget(
      postId: doc['postId'],
      postBody: doc['postBody'],
      authorName: doc['username'],
      authorId: doc['userId'],
      ameenReaction: doc['ameen'],
      postTime: doc['created_at'],
      authorPhoto: doc['profilePicture'],
    );
  }

  int getAmeenCount(ameen) {
    // if no likes, return 0
    if (ameenReaction == null) {
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


  @override
  _PostWidgetState createState() => _PostWidgetState(
        postId: this.postId,
        authorId: this.authorId,
        authorName: this.authorName,
        authorPhoto: this.authorPhoto,
        postBody: this.postBody,
        postTime: this.postTime,
        ameenReaction: this.ameenReaction,
        ameenCount: getAmeenCount(this.ameenReaction),
      );
}

class _PostWidgetState extends State<PostWidget> {
  _PostWidgetState(
      {Key key,
      this.postId,
      this.postBody,
      this.authorId,
      this.ameenCount,
      this.ameenReaction,
      this.authorName,
      this.authorPhoto,
      this.postTime});

  CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  CollectionReference postsRef = Firestore.instance.collection(DatabaseTable.posts);
  CollectionReference commentsRef = Firestore.instance.collection(DatabaseTable.comments);


  String postId;
  String postBody;
  String authorName;
  String authorId;
  String authorPhoto;
  Timestamp postTime;

  int ameenCount;
  int counterOfAmeen;
  int commentsCount;
  int counterOfComments;
  Map ameenReaction;

  @override
  void initState() {
    counterOfAmeen = ameenCount;
    _getTotalOfComments();
    super.initState();
  }

  // Get the number of total Comments
  _getTotalOfComments () {
   commentsRef
        .document(widget.postId)
        .collection(DatabaseTable.comments)
        .getDocuments()
        .then((data) {
          setState(() {
            commentsCount = data.documents.length;
            counterOfComments = commentsCount;
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
                  return  Container();
                }
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                    ),
                    _headOfPost(),

                    Container(
                      child: InkWell(
                        onTap: () => pushPage(context, PostPage(postId: postId, authorId: authorId, authorName: authorName)),
                        child: Column(
                          children: [
                            _postBody(),
                            _reactAndCommentCounter(),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    ReactionsButtons(
                      ameenReaction: ameenReaction,
                      ameenCount: ameenCount,
                      authorId: authorId,
                      postId: postId,

                    ),
                    InkWell(
                        onTap: () => pushPage(context, PostPage(postId: postId, authorId: authorId, authorName: authorName)),
                        child: AddNewCommentWidget(authorPhoto: authorPhoto,)),
                  ],
                );
              },
            ),
          );
  }

  Widget _postBody() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: AlignmentDirectional.topEnd,
      child: Text(
        postBody,
        style: TextStyle(
          fontFamily: 'Dubai',
          fontSize: 15,
        ),
      ),
    );
  }

//   The top Section of Post (Photo, Time, Settings, Name)
  Widget _headOfPost() {
    bool isPostOwner = currentUser.uid == authorId;

    // To handle function of selected Item in PopupMenuButton
    void choiceAction(String option) async {
      if (option == AppTexts.RemovePost) {
        _handleDeletePost(context);
      } else if (option == AppTexts.SavePost) {
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
                child: Visibility(visible: isPostOwner ? true : false, child: Text(AppTexts.RemovePost)),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: isPostOwner ? 30 : 0,
                value: AppTexts.RemovePost,
              ),

              /// Save Post Item
              PopupMenuItem(
                child: Text(AppTexts.SavePost),
                textStyle: TextStyle(
                    fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: 30,
                value: AppTexts.SavePost,
              ),
            ],
          ),
        ),

        // Show Name of the author, Time of post and Image of User
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Name of the user
                Container(
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
                _postTimeStamp(),

              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 22.0,
                backgroundImage: authorPhoto == null ? AssetImage(AppIcons.AnonymousPerson) : CachedNetworkImageProvider(authorPhoto),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Time of post created..
  Widget _postTimeStamp() {
    initializeDateFormatting();
    var timestamp = postTime.toDate();
    var date = DateFormat.yMMMd('ar').add_jm().format(timestamp);

    var timeTheme = new TextStyle(fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    initializeDateFormatting('ar');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(date.toString(), style: timeTheme, textAlign: TextAlign.end,),
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
              visible: counterOfComments != null && counterOfComments >= 1  ? true : false,
              child: Container(
                child: Row(
                  children: <Widget>[
                    // "Comment Word"
                    Text('تعليق', style: mytextStyle.reactCounterTextStyle),

                    // Number of comments
                    Text(counterOfComments== null ? '' : counterOfComments.toString(), style: mytextStyle.reactCounterTextStyle),

                  ],
                ),
              )),

          // Container of Numbers and Reactions Icons
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: counterOfAmeen >= 1 ? true : false,
            child: Container(
              margin: EdgeInsets.only(right: 5, left: 5),
              child: Row(
                children: <Widget>[
                  // Counter of Reaction (Numbers)
                  Container(
                    margin: EdgeInsets.only(right: 2, left: 2),
                    child: Text(
                      //Check if the Total Reactions = 0 or not
                      counterOfAmeen >= 1 ? counterOfAmeen.toString() : '',
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
                          visible: counterOfAmeen >= 1 ? true : false,
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
                    'نعم',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء')),
            ],
          );
        });
  }
}





