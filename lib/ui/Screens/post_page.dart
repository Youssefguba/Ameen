import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:get_it/get_it.dart';

class PostPage extends StatefulWidget {
  String postId = "5eb0be302bde512e94206279";
  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostsService get services => GetIt.I<PostsService>();
  APIResponse<PostDetails> _apiResponse;
  String errorMessage;
  PostDetails postDetails;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchPost();
  }

  _fetchPost() async {
    await services.getPostsDetails(widget.postId).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }
      postDetails = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: AppBar(
        title: Text("Youssef",
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w700,
                color: myColors.green[700])),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          disabledColor: myColors.cBackground,
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(Duration(seconds: 3));
          },
        child: Builder(builder: (context) {
          if (_isLoading) {
            return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(myColors.cBackground),
                  backgroundColor: myColors.cGreen,
            ));
          }
          return InheritedPostModel(
            postDetails: postDetails,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 0.1, // has the effect of softening the shadow
                    offset: new Offset(0.1, 0.1),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                  ),
                  /*
                 * The top Section of Post (Photo, Time, Settings, Name)
                 * */
                  _HeadOfPost(),

                  /*
                * The Beginning of Text of the Post
                * */
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      postDetails.postBody,
                      style: TextStyle(
                        fontFamily: 'Dubai',
                        fontSize: 15,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  /*
                * The End of Text of the Post
                * */

                  /*
                * The Beginning of Reaction Buttons Row
                * */
                  SizedBox(
                    height: 12,
                  ),
                  _ReactionsButtons(),
                  /*
                * The End of Reaction Buttons Row
                * */
                ],
              ),
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
* Reactions Buttons Widget (Ameen, Comment, Share)
* */
class _ReactionsButtons extends StatefulWidget {
  @override
  __ReactionsButtonsState createState() => __ReactionsButtonsState();
}

class __ReactionsButtonsState extends State<_ReactionsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          reactionsButtonRow(
              AssetImage("assets/images/share_icon.png"), 'مشاركة'),
          reactionsButtonRow(
              AssetImage("assets/images/comment.png"), 'تعليق'),
          reactionsButtonRow(
              AssetImage("assets/images/pray_icon.png"), 'آمين'),
        ],
      ),
    );
  }
}
