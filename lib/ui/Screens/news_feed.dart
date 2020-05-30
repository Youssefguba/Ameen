import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameen/ui/Screens/post_page.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ameen/blocs/global/global.dart';



/// * This page to display the General Timeline of posts
/// *
class NewsFeed extends StatefulWidget {
  const NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  SharedPreferences sharedPreferences;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null || sharedPreferences.getString('userId') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext buildContext) => Login()), (route) => false);
    } else {
      GlobalVariable.currentUserId = sharedPreferences.getString('userId');
    }
  }

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  PostsService get services => GetIt.I<PostsService>();
  APIResponse<List<PostData>> _apiResponse;
  bool _isLoading = false;
  var logger = Logger();
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
    _fetchPosts();

  }


  @override
  void dispose() {
    super.dispose();
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
      backgroundColor: MyColors.cBackground,
      appBar: customAppBar(),

      /// Refresh Indicator to Fetch Latest Data..
      body: ConnectivityCheck(
        child: RefreshIndicator(
          color:  MyColors.cGreen,
          backgroundColor: Colors.white,
          onRefresh: () async {
             await _fetchPosts();
          },
          child: Builder(builder: (context) {

            /// If the data don't retrieved yet it will show Progress Indicator until data retrieved
            if (_isLoading) {
              return Center(
                  child: RefreshProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
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
      ),
    );
  }
}
