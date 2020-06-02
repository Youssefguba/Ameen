import 'package:ameen/blocs/global/global.dart';
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

import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:ameen/helpers/ui/images.dart' as myImages;

import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PostPage extends StatefulWidget {
  final String postId;
  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<AnimatedListState> listOfComment = GlobalKey();
  SharedPreferences sharedPreferences;

  PostsService get services => GetIt.I<PostsService>();
  String errorMessage;
  CommentModel commentModel;
  PostDetails postDetails;

  bool _isLoading = false;
  var logger = Logger();


  _getUsernameOfUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    GlobalVariable.currentUserName = sharedPreferences.getString('username');
  }

  @override
  void initState() {
    super.initState();
    _fetchPost();
    _getUsernameOfUser();

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
        errorMessage = response.errorMessage ?? 'حدث خلل ما';
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
      backgroundColor: MyColors.cBackground,
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
                    color: MyColors.cBackground)),
        leading: IconButton(
          icon: ImageIcon(AssetImage(MyIcons.arrowBack)),
          onPressed: () {
            Navigator.of(context).pop(NewsFeed);
          },
          disabledColor: MyColors.cBackground,
        ),
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: MyColors.cBackground,
            valueColor: new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
          ));
        }
        return RefreshIndicator(
          color: MyColors.cGreen,
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
                        _PostBody(),

                        // React and Comment Counter
                        _ReactAndCommentCounter(),

                        // The Beginning of Reaction Buttons Row
                        SizedBox(height: 12),

                        _ReactionsButtons(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // List of a comments
                (postDetails.comments.length >= 1 )? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
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
                ) : Expanded(
                    child: Center(child: Text(Texts.NotFoundComments, style: TextStyle(fontSize: 18, fontFamily: 'Dubai', color: MyColors.cBlack)))),

                // Write a Comment Widget
                InheritedPostModel(
                    postDetails: postDetails, child: _WriteAComment()),
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
class _PostBody extends StatelessWidget {
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
  PostsService get services => GetIt.I<PostsService>();
  static const String removePost = 'حذف المنشور';
  static const String savePost = "حفظ المنشور في القائمة";

  @override
  Widget build(BuildContext context) {
    final PostDetails postDetails = InheritedPostModel.of(context).postDetails;
    // To handle function of selected Item in PopupMenuButton
    void choiceAction(String option) async {
      if(option == removePost){
        await services.removePost(postDetails.postId);
      } else if (option == savePost) {
        //TODO => Handle it Later to Save Post.
        print('Button Clicked');
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Show Popup More Button
        Flexible(
          // More button to show options of post.
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: choiceAction,
            itemBuilder: (context) => [

              /// Remove Post Item
              PopupMenuItem(
                // Check if the post is belong to the current User or not .. to show or remove (Remove Post)
                child: Visibility(
                    visible: postDetails.authorId == GlobalVariable.currentUserId ? true : false,
                    child: Text(removePost)),
                textStyle: TextStyle(fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: postDetails.authorId == GlobalVariable.currentUserId ? 30 : 0,
                value: removePost,
              ),

              /// Save Post Item
              PopupMenuItem(
                child: Text(savePost),
                textStyle: TextStyle(fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: 30,
                value: savePost,

              ),
            ],
          ),
        ),

        /// Show Name of the author, Time of post and Image of User
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
class _ReactAndCommentCounter extends StatefulWidget {
  // Reaction Counter
  @override
  __ReactAndCommentCounterState createState() =>
      __ReactAndCommentCounterState();
}

/*
* react counter
* */
class __ReactAndCommentCounterState extends State<_ReactAndCommentCounter> {
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
class _WriteAComment extends StatefulWidget {
  @override
  _WriteACommentState createState() => _WriteACommentState();
}

class _WriteACommentState extends State<_WriteAComment> {
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
            color: MyColors.cBackground,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Submit Icon Button to Add Comment to List..
            IconButton(
                iconSize: 24,
                focusColor: MyColors.cGreen,
                splashColor: MyColors.cGreen,
                disabledColor: MyColors.cGreen,
                icon: Icon(Icons.send,
                    color: MyColors.cGreenDark,
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
                    final comment = CommentModel(commentBody: _text.text, authorName: GlobalVariable.currentUserName, authorId: GlobalVariable.currentUserId);
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
                cursorColor: MyColors.cGreenDark,
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
class _ReactionsButtons extends StatefulWidget {
  @override
  _ReactionsButtonsState createState() => _ReactionsButtonsState();
}

/*
 *  Action Buttons Widgets like..
 *       (Like, Comment, Share)
 **/
class _ReactionsButtonsState extends State<_ReactionsButtons>
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
                          (isPressed) ? MyColors.cGreen : MyColors.cTextColor,
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
                          (isPressed) ? MyColors.cGreen : MyColors.cTextColor,
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
                  animControlBtnShortPress.forward();
                });
              } else {
                setState(() async {
                  isPressed = false;
                  animControlBtnShortPress.reverse();
                  services.removeAmeenReact(postDetails.postId, GlobalVariable.currentUserId);
                  logger.v('ameen id', ameenReact.ameenId);
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
                  color: MyColors.cTextColor,
                )),
          ),

          //Share Button
          ReactionsButtonRow(
            image: Image.asset(shareImage, width: 20, height: 20),
            label: Text("مشاركة",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: MyColors.cTextColor,
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
