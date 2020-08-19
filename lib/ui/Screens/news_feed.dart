import 'dart:io';

import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// ** This page to display the General Timeline of posts
class NewsFeed extends StatefulWidget {
  final FirebaseUser currentUser;

  NewsFeed({Key key, this.currentUser}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed>
    with AutomaticKeepAliveClientMixin<NewsFeed> {
  static const TAG = 'News_feed';
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<PostWidget> posts = [];
  bool _isLoading = false;
  Locale locale;

  @override
  void initState() {
    super.initState();
    _loadMoreInTimeline();
    getTimeline();
    configurePushNotification();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
    _scrollController.dispose();
  }

  void _loadMoreInTimeline() {
    _scrollController.addListener(() {
      if (_scrollController.position.outOfRange) {
        if (_scrollController.position.pixels == 0) {
          print('$TAG, at the bottom');
        } else {
          print('$TAG, at the top');
        }
      }
    });
  }

  void getTimeline() async {
    setState(() => _isLoading = true);
    QuerySnapshot snapshot = await DbRefs.timelineRef
        .orderBy('created_at', descending: true)
        .getDocuments();

    setState(() {
      posts = snapshot.documents
          .map((doc) => PostWidget.fromDocument(doc))
          .toList();
    });

    setState(() => _isLoading = false);
  }

  void configurePushNotification() {
    if (Platform.isIOS) getIOSPermission();
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print('Firebase Messaging token $token');
      usersRef
          .document(widget.currentUser.uid)
          .updateData({'androidNotificationToken': token});
    });

    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('on Launch $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on Resume $message');
      },
      onMessage: (Map<String, dynamic> message) async {
        print('This is a message $message');
        final recipientId = message['data']['recipient'];
        print('This is a recripientID');
        final body = message['notification']['body'];
        if (recipientId == widget.currentUser.uid) {
          print('Notification shown');
        }
        print('Notification NOT shown');
      },
    );
  }

  void getIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings registered: $settings");
    });
  }

  buildTimeline() {
    if (posts == null) {
      return ShimmerWidget();
    } else if (posts.isEmpty) {
      return Center(
        child: Text('لا يوجد أدعية قم بمشاركة دعاءك الذي تتمنه أن يتحقق'),
      );
    } else {
      return ListView(
        children: posts,
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        semanticChildCount: posts.length % 2,
        shrinkWrap: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cBackground,
      appBar: customAppBar(context, widget.currentUser),
      // Refresh Indicator to Fetch Latest Data..
      body: ConnectivityCheck(
        child: RefreshIndicator(
          color: AppColors.cGreen,
          backgroundColor: Colors.white,
          onRefresh: () async => getTimeline(),
          child: _isLoading
              ? ShimmerWidget()
              : Container(
                  child: Column(
                    children: <Widget>[
                      AddNewPostWidget(currentUser: widget.currentUser),
                      Flexible(
                        child: _isLoading ? ShimmerWidget() : buildTimeline(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
