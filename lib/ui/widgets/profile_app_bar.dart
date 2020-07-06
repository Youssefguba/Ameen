import 'package:ameen/ui/Screens/chat_page.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatefulWidget {
  String profileId;
  FirebaseUser currentUser;
  ProfileAppBar({Key key, @required this.profileId, @required this.currentUser}): super(key: key);

  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  final double appBarHeight = 80.0;
  UserModel user;
  String userId;
  String errorMessage;
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    _checkIfFollowing();
    _getFollowers();
    _getFollowing();
  }

  _checkIfFollowing() async {
    DocumentSnapshot doc = await DbRefs.followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(userId)
        .get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

  _getFollowers() async {
    QuerySnapshot snapshot = await DbRefs.followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  _getFollowing() async {
    QuerySnapshot snapshot = await DbRefs.followingRef
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  _handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });

    // remove follower
    DbRefs.followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(widget.currentUser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // remove following
    DbRefs.followingRef
        .document(widget.currentUser.uid)
        .collection('userFollowing')
        .document(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete activity feed item for them
    DbRefs.activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(widget.currentUser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  _handleFollowUser() {
    setState(() {
      isFollowing = true;
    });

    // Make auth user follower of THAT user (update THEIR followers collection)
    DbRefs.followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(widget.currentUser.uid)
        .setData({});

    // Put THAT user on YOUR following collection (update your following collection)
    DbRefs.followingRef
        .document(widget.currentUser.uid)
        .collection('userFollowing')
        .document(widget.profileId)
        .setData({});

    // add activity feed item for that user to notify about new follower (us)
    DbRefs.activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(widget.currentUser.uid)
        .setData({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": user.username,
      "userId": widget.currentUser.uid,
      "profilePicture": user.profilePicture,
      "timestamp": DateTime.now(),
    });
  }

   _showDoaaButton() {
    bool isProfileOwner = widget.currentUser.uid == widget.profileId;
    if(isProfileOwner) {
      return _addDoaaButton(context);
    }
    else if (isFollowing) {
      return _followButton(
        context,
        text: AppLocalizations.of(context).unfollow,
        function: _handleUnfollowUser,
      );
    }
    else if (!isFollowing) {
      return _followButton(
        context,
        text: AppLocalizations.of(context).follow,
        function: _handleFollowUser,
      );
    }
  }

  _showSendMessageBtn() {
      bool isProfileOwner = widget.currentUser.uid == widget.profileId;
      if(isProfileOwner) {
        return Container();
      }
      else if (isFollowing || !isFollowing) {
        return _sendMessageButton(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return FutureBuilder(
      future: DbRefs.usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Container();
        }
        user = UserModel.fromDocSnapshot(snapshot.data);
        return Container(
          padding: new EdgeInsets.only(top: statusBarHeight),
          height: statusBarHeight + appBarHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage:  user.profilePicture == null ? AssetImage(AppImages.AnonymousPerson): CachedNetworkImageProvider(user.profilePicture),
                ),
                Container(
                  child: Text(
                    user.username,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Dubai',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                _followersAndFollowingRow(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _showSendMessageBtn(),
                    _showDoaaButton(),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _addDoaaButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: FlatButton(
        onPressed: () => pushPage(context, CreatePost(currentUser: widget.currentUser)),
        color: AppColors.green[900],
        padding: EdgeInsets.all(5),
        hoverColor: Colors.white,
        textColor: Colors.white,
        disabledColor: AppColors.green,
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        child: Text(
          AppLocalizations.of(context).addADoaa,
          style:
              TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
        ),
      ),
    );
  }

  Widget _sendMessageButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: FlatButton(
        color: AppColors.green[900],
        padding: EdgeInsets.all(5),
        hoverColor: Colors.white,
        textColor: Colors.white,
        disabledColor: AppColors.green,
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        onPressed: () { pushPage(context, ChatScreen(peerId: widget.profileId, peerAvatar: user.profilePicture, peerUsername: user.username, )); },
        child: Text(
          AppLocalizations.of(context).sendMessage,
          style:
          TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
        ),
      ),
    );
  }

  Widget _followButton(BuildContext context, {String text, Function function}) {
    return FlatButton(
      onPressed: function,
      color: AppColors.green[900],
      padding: EdgeInsets.all(5),
      hoverColor: Colors.white,
      textColor: Colors.white,
      disabledColor: AppColors.green,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
      child: Text(
        text,
        style:
        TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
      ),
    );
  }

  Widget _followersAndFollowingRow() {
    return Container(
      padding: EdgeInsets.all(13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            // Followers Text
            child: Text(
              "${AppLocalizations.of(context).followers} ${followerCount}  ",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Dubai',
                  fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
    );
  }
}
