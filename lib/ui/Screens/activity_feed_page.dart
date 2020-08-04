import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatelessWidget {
  FirebaseUser currentUser;
  ActivityFeed({this.currentUser});
  CollectionReference activityFeedRef =
      Firestore.instance.collection(DatabaseTable.feeds);

  _getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.uid)
        .collection('feedItems')
        .orderBy('created_at', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];

    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context).notification,
        style: TextStyle(fontFamily: 'Dubai'),
      )),
      body: Container(
          child: FutureBuilder(
        future: _getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ShimmerWidget();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

String activityItemText;

class ActivityFeedItem extends StatefulWidget {
  final String username;
  final String userId;
  final String type; // 'ameen', 'follow', 'comment'
  final String postId;
  final String profilePicture;
  final String commentBody;
  final Timestamp created_at;
  final PostData postModel;
  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.postId,
    this.commentBody,
    this.profilePicture,
    this.created_at,
    this.postModel,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      profilePicture: doc['profilePicture'],
      commentBody: doc['commentBody'],
      created_at: doc['created_at'],
    );
  }

  @override
  _ActivityFeedItemState createState() => _ActivityFeedItemState();
}

class _ActivityFeedItemState extends State<ActivityFeedItem> {
  dynamic userData;
  UserModel user;
  String username;

  @override
  void initState() {}

  // Get user data
  _getUserData() {
    userData = getCurrentUserData(userId: currentUser.uid);
    userData.then((doc) => setState(() {
          user = UserModel.fromDocument(doc);
          username = user.username;
          print(user.uid);
        }));
  }

  configureMediaPreview(BuildContext context) {
    if (widget.type == 'amen') {
      activityItemText = AppLocalizations.of(context).reactAsAmen;
    } else if (widget.type == 'recommend') {
      activityItemText = AppLocalizations.of(context).reactAsRecommend;
    } else if (widget.type == 'forbidden') {
      activityItemText = AppLocalizations.of(context).reactAsForbidden;
    } else if (widget.type == 'follow') {
      activityItemText = AppLocalizations.of(context).followsYou;
    } else if (widget.type == 'comment') {
      activityItemText =
          '${AppLocalizations.of(context).commentOnYourPost} ${widget.commentBody}';
    } else {
      activityItemText = "Error: Unknown type '${widget.type}'";
    }
  }

  @override
  Widget build(BuildContext context) {
    var timestamp = widget.created_at.toDate();
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: ListTile(
          title: GestureDetector(
            onTap: () => {
              pushPage(
                  context,
                  PostPage(
                      postId: widget.postId,
                      authorId: currentUser.uid,
                      authorName: username)),
            },
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: widget.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: widget.profilePicture == null
                ? AssetImage(AppImages.AnonymousPerson)
                : CachedNetworkImageProvider(widget.profilePicture),
          ),
          subtitle: Text(
            timeago.format(timestamp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
