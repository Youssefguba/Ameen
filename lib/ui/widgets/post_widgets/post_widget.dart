import 'package:ameen/blocs/global/global.dart';
import 'package:ameencommon/models/post_data.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/widgets/comment/add_new_comment.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart'; //for date locale
import 'package:ameen/helpers/ui/images.dart' as myImages;
import 'package:ameen/helpers/ui/text_styles.dart' as mytextStyle;
import 'package:logger/logger.dart';

/*
* This class represent the UI of Post and every thing related with it..
* Y.G
* */
class PostWidget extends StatelessWidget {
  final PostData postModel;
  final UserModel userModel;
  const PostWidget({Key key, this.postModel, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedPostModel(
      postData: postModel,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.5, // has the effect of softening the shadow
              offset: new Offset(0.5, 0.5),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
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
            _PostBody(),
            /*
            * The End of Text of the Post
            * */

            _ReactAndCommentCounter(),
            /*
            * The Beginning of Reaction Buttons Row
            * */
            SizedBox(
              height: 8,
            ),
            ReactionsButtons(),
            /*
            * The End of Reaction Buttons Row
            * */
            AddNewCommentWidget(),
          ],
        ),
      ),
    );
  }
}

/*
*  The Body of the Post ..
**/
class _PostBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostData postData = InheritedPostModel.of(context).postData;

    return Container (
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: AlignmentDirectional.topEnd,
      child: Text(
        postData.body,
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
    final PostData postData = InheritedPostModel.of(context).postData;

    // To handle function of selected Item in PopupMenuButton
    void choiceAction(String option) async {
      if(option == removePost){
        await services.removePost(postData.postId);
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
                    visible: postData.authorId == GlobalVariable.currentUserId ? true : false,
                    child: Text(removePost)),
                textStyle: TextStyle(fontSize: 12, fontFamily: 'Dubai', color: Colors.black),
                height: postData.authorId == GlobalVariable.currentUserId ? 30 : 0,
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

                // Name of the user
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
                  child: Text(
                    postData.authorName,
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 15,
                    ),
                  ),
                ),

                // Time of the post
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
    final PostData postData = InheritedPostModel.of(context).postData;
    var timeTheme = new TextStyle(
        fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    initializeDateFormatting('ar');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(postData.postTimeFormatted, style: timeTheme),
    );
  }
}

/*
* react counter
* */
class _ReactAndCommentCounter extends StatefulWidget {
  String reactionCounter;
  _ReactAndCommentCounter({Key key, this.reactionCounter}) : super(key: key);

  @override
  _ReactAndCommentCounterState createState() => _ReactAndCommentCounterState();
}

class _ReactAndCommentCounterState extends State<_ReactAndCommentCounter> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final PostData postData = InheritedPostModel.of(context).postData;
    var _ameenCounter;
    var _recommendCounter = postData.recommendReaction.length;
    var _forbiddenCounter = postData.forbiddenReaction.length;
    var _totalReactions = 0;

    setState(() {
      _ameenCounter = postData.ameenReaction.length;
      _totalReactions = _ameenCounter + _recommendCounter + _forbiddenCounter;
    });

    return InheritedPostModel(
      postData: postData,
      child: Container(
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
                        //Check if the Total Reactions = 0 or not
                        _totalReactions >= 1 ? "$_ameenCounter" : '',
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
                visible: postData.comments.length >= 1 ? true : false,
                child: Container(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      // Number of comments
                      Text(postData.comments.length.toString(),
                          style: mytextStyle.reactCounterTextStyle),
                      // "Comment Word"
                      Text('تعليق', style: mytextStyle.reactCounterTextStyle),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
