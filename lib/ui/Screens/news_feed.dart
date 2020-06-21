import 'package:ameencommon/models/api_response.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ** This page to display the General Timeline of posts
class NewsFeed extends StatefulWidget {
  FirebaseUser currentUser;

  NewsFeed({Key key, this.currentUser}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final logger = Logger();

  PostsService get services => GetIt.I<PostsService>();
  APIResponse<List<PostData>> _apiResponse;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }


  _fetchPosts() async {
    setState(() => _isLoading = true );
    _apiResponse = await services.getPostsList();
    setState(() => _isLoading = false );
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cBackground,
      appBar: customAppBar(context, widget.currentUser),
      // Refresh Indicator to Fetch Latest Data..
      body: ConnectivityCheck(
        child: RefreshIndicator(
          color:  AppColors.cGreen,
          backgroundColor: Colors.white,
          onRefresh: () async => await _fetchPosts(),
          child: Builder(builder: (context) {
            // If the data don't retrieved yet it will show Progress Indicator until data retrieved
            if (_isLoading) {
              return Center(
                  child: RefreshProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.cGreen),
              ));
            }
            if (_apiResponse.error) Center(child: Text(_apiResponse.errorMessage));
            return Container(
              child: Column(
                  children: <Widget>[
                    // Add New Post Widget at the Top and Fixed when Scrolling
                    AddNewPostWidget(currentUser: widget.currentUser),
                    SizedBox(height: 0.5),
                    // List of Posts of Users
                    Expanded(
                      child: AnimatedList(
                          key: listKey,
                          controller: ScrollController(),
                          initialItemCount: _apiResponse.data.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index, Animation anim) {
                            return GestureDetector(
                              child: PostWidget(),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        fullscreenDialog: true,
                                        maintainState: true ,
                                        builder: (_) => PostPage(
                                              postId: _apiResponse.data[index].postId,
                                            )))
                                    .then((_) {
                                  _fetchPosts();
                                });
                              },
                            );
                          }),
                    ),
                  ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
