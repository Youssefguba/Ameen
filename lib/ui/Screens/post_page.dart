import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/blocs/models/reaction_model.dart';
import 'package:ameen/services/connection_check.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:ameen/ui/widgets/comment/comment_widget.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:ameen/helpers/ui/images.dart' as myImages;

import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:toast/toast.dart';

class PostPage extends StatefulWidget {
  final String postId;
  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<AnimatedListState> listOfComment = GlobalKey();

  PostsService get services => GetIt.I<PostsService>();
  String errorMessage;
  CommentModel commentModel;
  PostDetails postDetails;
  APIResponse<List<CommentModel>> _apiResponse;

  bool _isLoading = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Called When Clicked on the post from the NewsFeed page to get the details and enter the Post Page.
  _fetchPost() async {
    setState(() {
      _isLoading = true;
    });
    await services.getPostsDetails(widget.postId).then((response) {
      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }
      postDetails = response.data;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: AppBar(
        title: _isLoading
            ? Text('')
            : Text(
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
          onPressed: () {
            Navigator.of(context).pop(NewsFeed);
          },
          disabledColor: myColors.cBackground,
        ),
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: myColors.cBackground,
            valueColor: new AlwaysStoppedAnimation<Color>(myColors.cGreen),
          ));
        }
        return RefreshIndicator(
          color: myColors.cGreen,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await _fetchPost();
          },
          child: Container(
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

                        // React and Comment Counter
                        _reactAndCommentCounter(),

                        // The Beginning of Reaction Buttons Row
                        SizedBox(height: 12),

                        _reactionsButtons(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // List of a comments
                Expanded(
                  child: AnimatedList(
                      initialItemCount: postDetails.comments.length,
                      itemBuilder:
                          (BuildContext context, int index, Animation anim) {
                        return SizeTransition(
                          axis: Axis.vertical,
                          sizeFactor: anim,
                          child: CommentWidget(
                              commentModel: postDetails.comments[index]),
                        );
                      }),
                ),

                // Write a Comment Widget
                InheritedPostModel(
                    postDetails: postDetails, child: _writeAComment()),
              ],
            ),
          ),
        );
      }),

//      bottomNavigationBar:
//            AddNewPostWidget("أكتب تعليقا ...", Colors.grey[300]),
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
              width: 50,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                maxRadius: 20.0,
                minRadius: 10.0,
                backgroundImage: AssetImage('assets/images/icon_person.png'),
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
    initializeDateFormatting('ar');

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
class _reactAndCommentCounter extends StatefulWidget {
  // Reaction Counter
  @override
  __reactAndCommentCounterState createState() =>
      __reactAndCommentCounterState();
}

/*
* react counter
* */
class __reactAndCommentCounterState extends State<_reactAndCommentCounter> {
  var _ameenCounter;

  var _recommendCounter;

  var _forbiddenCounter;

  var _totalReactions;

  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;
    _ameenCounter = postDetails.ameenReaction.length;
    _recommendCounter = postDetails.recommendReaction.length;
    _forbiddenCounter = postDetails.forbiddenReaction.length;
    _totalReactions = _ameenCounter + _recommendCounter + _forbiddenCounter;

    setState(() {
      _totalReactions = _ameenCounter + _recommendCounter + _forbiddenCounter;
    });

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
                      _totalReactions >= 1 ? "$_totalReactions" : '',
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
                          visible: _ameenCounter >= 1 ? true : false,
                          child: myImages.ameenIconReactCounter,
                        ),

                        // Recommend React
                        Visibility(
                          visible: _recommendCounter >= 1 ? true : false,
                          child: myImages.recommendIconReactCounter,
                        ),

                        // Forbidden React
                        Visibility(
                          visible: _forbiddenCounter >= 1 ? true : false,
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
            visible: postDetails.comments.length > 1 ? true : false,
            child: Container(
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  // Number of comments
                  Text(postDetails.comments.length.toString(),
                      style: mytextStyle.reactCounterTextStyle),

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

/*
* Add a Comment Widget
* */
class _writeAComment extends StatefulWidget {
  @override
  __writeACommentState createState() => __writeACommentState();
}

class __writeACommentState extends State<_writeAComment> {
  PostsService get services => GetIt.I<PostsService>();
  TextEditingController _text = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1, color: Colors.grey.shade500),
      ),
      height: 50,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            color: myColors.cBackground,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Submit Icon Button to Add Comment to List..
            IconButton(
                iconSize: 24,
                focusColor: myColors.cGreen,
                splashColor: myColors.cGreen,
                disabledColor: myColors.cGreen,
                icon: Icon(Icons.send,
                    color: myColors.cGreenDark,
                    size: 24,
                    textDirection: TextDirection.rtl),
                onPressed: () async {

                  /// Check if Text Field is Empty or not..
                  if (_text.text.isEmpty) {
                    Toast.show(
                      "التعليق ليس به أي محتوى",
                      context,
                      backgroundColor: Colors.red.shade700,
                      textColor: Colors.white,
                      gravity: Toast.BOTTOM,
                      duration: Toast.LENGTH_SHORT,
                    );
                  } else {
                    final comment = CommentModel(commentBody: _text.text);
                    // Check Internet Connection..
                    ConnectivityCheck();
                    await services.addComment(comment, postDetails.postId);
                    // Clear the text after Comment Added..
                    _text.clear();
                  }
                }),

            /// Text Field(Input) of Comment..
            Expanded(
              child: TextField(
                maxLines: 20,
                dragStartBehavior: DragStartBehavior.down,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                showCursor: true,
                cursorColor: myColors.cGreenDark,
                controller: _text,
                scrollPhysics: ScrollPhysics(),
                enabled: true,
                scrollController: ScrollController(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: " ... أكتب تعليق ",
                  hintStyle: TextStyle(
                    fontFamily: 'Dubai',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 *  Action Buttons Widgets like..
 *       (Like, Comment, Share)
 **/
class _reactionsButtons extends StatefulWidget {
  @override
  _reactionsButtonsState createState() => _reactionsButtonsState();
}

/*
 *  Action Buttons Widgets like..
 *       (Like, Comment, Share)
 **/
class _reactionsButtonsState extends State<_reactionsButtons>
    with TickerProviderStateMixin {
  PostsService get services => GetIt.I<PostsService>();
  // Reactions Icon
  final ameenImage = "assets/images/pray_icon.png";
  final commentImage = "assets/images/comment.png";
  final shareImage = "assets/images/share_icon.png";

  // Reaction Counter
  var ameenCounter;
  var recommendCounter;
  var forbiddenCounter;
  var totalReactions;

  var ameenReact = AmeenReaction();
  bool isPressed = false;
  var logger = Logger();

  int durationAnimationBtnShortPress = 500;

  //Animation
  Animation zoomIconAmeenInBtn2, tiltIconAmeenInBtn2;
  AnimationController animControlBtnShortPress;

  @override
  void initState() {
    super.initState();
    initAmeenBtn();
  }

  initAmeenBtn() {
    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconAmeenInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconAmeenInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);
    zoomIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconAmeenInBtn2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;
    ameenCounter = postDetails.ameenReaction.length;
    recommendCounter = postDetails.recommendReaction.length;
    forbiddenCounter = postDetails.forbiddenReaction.length;
    totalReactions = ameenCounter + recommendCounter + forbiddenCounter;

    setState(() {
      totalReactions = ameenCounter + recommendCounter + forbiddenCounter;
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),

      // Reactions Buttons => [Ameen - Comment - Share]
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          //Ameen Button
          InkWell(
            child: ReactionsButtonRow(
              image: Transform.scale(
                scale: (isPressed)
                    ? handleOutputRangeZoomInIconAmeen(
                        zoomIconAmeenInBtn2.value)
                    : zoomIconAmeenInBtn2.value,
                child: Transform.rotate(
                  angle: (isPressed)
                      ? handleOutputRangeTiltIconAmeen(
                          tiltIconAmeenInBtn2.value)
                      : tiltIconAmeenInBtn2.value,
                  child: Image.asset(ameenImage,
                      color:
                          (isPressed) ? myColors.cGreen : myColors.cTextColor,
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20),
                ),
              ),
              label: Transform.scale(
                scale:
                    handleOutputRangeZoomInIconAmeen(zoomIconAmeenInBtn2.value),
                child: Text("آمين",
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 13,
                      color:
                          (isPressed) ? myColors.cGreen : myColors.cTextColor,
                      fontWeight:
                          (isPressed) ? FontWeight.w600 : FontWeight.normal,
                    )),
              ),
            ),
            onTap: () {
              if (!isPressed) {
                setState(() {
                  isPressed = true;
                  services.ameenReact(postDetails.postId, ameenReact);
                  postDetails.ameenReaction.add(ameenReact);
                  animControlBtnShortPress.forward();
                });
              } else {
                setState(() {
                  isPressed = false;
                  animControlBtnShortPress.reverse();
                  services.removeAmeenReact(
                      postDetails.postId, "5eb0c28fe1be6b44a094cbf7");
                });
              }
            },
          ),

          //Comment Button
          ReactionsButtonRow(
            image: Image.asset(commentImage, width: 20, height: 20),
            label: Text("تعليق",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: myColors.cTextColor,
                )),
          ),

          //Share Button
          ReactionsButtonRow(
            image: Image.asset(shareImage, width: 20, height: 20),
            label: Text("مشاركة",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: myColors.cTextColor,
                )),
          ),
        ],
      ),
    );
  }

  double handleOutputRangeTiltIconAmeen(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  double handleOutputRangeZoomInIconAmeen(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }
}
