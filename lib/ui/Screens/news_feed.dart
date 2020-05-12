import 'dart:developer';

import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  PostsService get services => GetIt.I<PostsService>();
  APIResponse<List<PostData>> _apiResponse;
  bool _isLoading = false;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await services.getPostsList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: CustomAppBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            return _fetchPosts();
          },
          child: Builder(builder: (context) {
          if (_isLoading) {
            return Center(
                child: CircularProgressIndicator(
                  backgroundColor: myColors.cBackground,
                  valueColor: new  AlwaysStoppedAnimation<Color>(myColors.cGreen),
                ));
          }
          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }
          return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                          itemCount: _apiResponse.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: PostWidget(postModel: _apiResponse.data[index]),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => PostPage(
                                          postId: _apiResponse.data[index].postId,
                                        ))).then((_) {
                                          _fetchPosts();
                                });
                              },
                            );
                          }
                  ),
                ),
              ],
          );
        }),
      ),
    );
  }
}
