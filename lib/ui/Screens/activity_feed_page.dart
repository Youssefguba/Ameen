import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/localizations.dart';
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
  CollectionReference activityFeedRef = Firestore.instance.collection(DatabaseTable.feeds);

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
      appBar: AppBar( title: Text (AppLocalizations.of(context).notification, style: TextStyle(fontFamily: 'Dubai'),)),
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

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'ameen', 'follow', 'comment'
  final String postId;
  final String profilePicture;
  final String commentBody;
  final Timestamp created_at;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.postId,
    this.commentBody,
    this.profilePicture,
    this.created_at,
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

  configureMediaPreview(BuildContext context) {
    if (type == 'amen') {
      activityItemText = AppLocalizations.of(context).reactAsAmen;
    } else if (type == 'recommend') {
      activityItemText = AppLocalizations.of(context).reactAsRecommend;
    }else if (type == 'forbidden') {
      activityItemText = AppLocalizations.of(context).reactAsForbidden;
    }else if (type == 'follow') {
      activityItemText = AppLocalizations.of(context).followsYou;
    } else if (type == 'comment') {
      activityItemText = '${AppLocalizations.of(context).commentOnYourPost} $commentBody';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    var timestamp = created_at.toDate();
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: ListTile(
          title: GestureDetector(
            onTap: () => {
              pushPage(context, PostPage(postId: postId, authorId: currentUser.uid)),

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
                      text: username,
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
            backgroundImage: profilePicture == null ? AssetImage(AppImages.AnonymousPerson): CachedNetworkImageProvider(profilePicture),
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

