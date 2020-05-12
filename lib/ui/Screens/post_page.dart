import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/widgets/comment/comment_widget.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';

import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:ameen/helpers/ui/images.dart' as myImages;

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class PostPage extends StatefulWidget {
  final String postId;
  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostsService get services => GetIt.I<PostsService>();
  String errorMessage;
  CommentModel commentModel;
  PostDetails postDetails;
  APIResponse<List<CommentModel>> _apiResponse;

  bool _isLoading = false;
  var logger = Logger();

  @override
  void initState() {
    _fetchPost();
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  // Called When Clicked on the post from the newsfeed page to get the details and enter the Post Page.
  _fetchPost() async {
    await services.getPostsDetails(widget.postId).then((response) {
//      logger.v("PostPage",response.data);
      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }
      postDetails = response.data;

      setState(() {
        _isLoading = false;
      });
    });
  }

//  _fetchComments() async {
//    setState(() {
//      _isLoading = true;
//    });
//
//    _apiResponse = await services.getCommentList(widget.postId);
//      logger.v("CommentsOfPost", _apiResponse);
//
//    setState(() {
//      _isLoading = false;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.cBackground,
        appBar: AppBar(
        title: _isLoading ? Text('') : Text(
          //Put the name of the author's post on the Appbar
            postDetails.authorName ??= '',
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w700,
                color: myColors.cBackground)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          disabledColor: myColors.cBackground,
        ),
      ),
        body: ConnectivityCheck(
          child: Builder(builder: (context) {
            if (_isLoading) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: myColors.cBackground,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(myColors.cGreen),
              ));
            }
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InheritedPostModel(
                    postDetails: postDetails,
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white10,
                            blurRadius:
                                0.1, // has the effect of softening the shadow
                            offset: new Offset(0.1, 0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13)),

                          // The top Section of Post (Photo, Time, Settings, Name)
                          _HeadOfPost(),

                          // The post of the Post
                          _postBody(),

                          _reactAndCommentCounter(),

                          // The Beginning of Reaction Buttons Row
                          SizedBox(height: 12),

                          ReactionsButtons(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                        itemCount: postDetails.comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: CommentWidget(commentModel: postDetails.comments[index]),

                          );
                        }
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

      bottomNavigationBar:
            AddNewPostWidget("أكتب تعليقا ...", Colors.grey[300]),
      );
  }
}

/*
*  The  Body of the Post
 * */
class _postBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;

    return Container(
      alignment: AlignmentDirectional.topEnd,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Text(
        postDetails.body,
        style: TextStyle(
          fontFamily: 'Dubai',
          fontSize: 15,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

/*
  * The top Section of Post (Photo, Time, Settings, Name)
  * */

class _HeadOfPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: IconButton(
            icon: Icon(Icons.more_horiz),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
                  child: Text(
                    postDetails.authorName,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 15,
                    ),
                  ),
                ),
                _PostTimeStamp(),
              ],
            ),
            Container(
              width: 45,
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*
* Time of post created..
* */
class _PostTimeStamp extends StatelessWidget {
  const _PostTimeStamp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;
    var timeTheme = new TextStyle(
        fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(postDetails.postTimeFormatted, style: timeTheme),
    );
  }
}

/*
* react counter
* */
class _reactAndCommentCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: EdgeInsets.all(8),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Container of Numbers and Reactions Icons
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: true,
            child: Container(
              margin: EdgeInsets.only(right: 5, left: 5),
              child: Row(
                children: <Widget>[
                  // Counter of Reaction (Numbers)
                  Container(
                    margin: EdgeInsets.only(right: 2, left: 2),
                    child: Text(
                      '15',
                      style: mytextStyle.reactCounterTextStyle,
                    ),
                  ),

                  // Counter of Reaction (Icons)
                  Container(
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Ameen React
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: true,
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

          // Counter of Comments (Numbers)
          Visibility(
            child: Container(
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  // Number of comments
                  Text('15', style: mytextStyle.reactCounterTextStyle),

                  // "Comment Word"
                  Text('تعليق', style: mytextStyle.reactCounterTextStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
