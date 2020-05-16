import 'dart:developer';

import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/reaction_model.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:logger/logger.dart';


/// * This page to display the General Timeline of posts
/// *
class NewsFeed extends StatefulWidget {
  const NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  PostsService get services => GetIt.I<PostsService>();
  APIResponse<List<PostData>> _apiResponse;
  bool _isLoading = false;
  var logger = Logger();
  @override
  void initState() {
    _fetchPosts();
    super.initState();

  }

  _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await services.getPostsList();
    setState(() {
      _isLoading = false;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: CustomAppBar(),

      /// Refresh Indicator to Fetch Latest Data..
      body: LiquidPullToRefresh(
        color:  myColors.cGreen,
        backgroundColor: Colors.white,
        showChildOpacityTransition: false,
        onRefresh: () async {
           await _fetchPosts();
        },
        animSpeedFactor: 2.0,
        child: Builder(builder: (context) {

          /// If the data don't retrieved yet it will show Progress Indicator until data retrieved
          if (_isLoading) {
            return Center(
                child: RefreshProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(myColors.cGreen),
            ));
          }
          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }

          return Container(
            child: Column(
                children: <Widget>[

                  /// Add New Post Widget at the Top and Fixed when Scrolling
                  AddNewPostWidget(),
                  SizedBox(height: 0.5),

                  /// List of Posts of Users
                  Expanded(
                    child: AnimatedList(
                        key: listKey,
                        controller: ScrollController(),
                        initialItemCount: _apiResponse.data.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index, Animation anim) {
                          return GestureDetector(
                            child: PostWidget(postModel: _apiResponse.data[index]),
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
    );
  }
}
