import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/// ** This page to display the General Timeline of posts
class NewsFeed extends StatefulWidget {
  final FirebaseUser currentUser;

  NewsFeed({Key key, this.currentUser}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed>  with AutomaticKeepAliveClientMixin<NewsFeed> {
  List<PostWidget> posts = [];
  bool _isLoading = false;


  @override
  void initState() {
    getTimeline();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
  }

  getTimeline() async {
    setState(() => _isLoading = true);
    QuerySnapshot snapshot = await DbRefs.timelineRef
        .orderBy('created_at', descending: true)
        .getDocuments();

    posts =
    snapshot.documents.map((doc) => PostWidget.fromDocument(doc)).toList();
    setState(() => _isLoading = false);

  }

  buildTimeline() {
    if (posts == null) {
      return RefreshProgress();
    } else if (posts.isEmpty) {
      return Center(child: Text('لا يوجد أدعية قم بمشاركة دعاءك الذي تتمنه أن يتحقق'),);
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.cBackground,
      appBar: customAppBar(context, widget.currentUser),
      // Refresh Indicator to Fetch Latest Data..
      body: ConnectivityCheck(
        child: RefreshIndicator(
          color:  AppColors.cGreen,
          backgroundColor: Colors.white,
          onRefresh: () async => getTimeline(),
           child:  _isLoading ? RefreshProgress() : Container(
            child: Column(
              children: <Widget>[
                AddNewPostWidget(currentUser: widget.currentUser),
                Expanded(child:  _isLoading ? RefreshProgress() : buildTimeline(),),
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
