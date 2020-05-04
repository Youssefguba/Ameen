import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';

/*
* This class represent the UI of Post and every thing related with it..
* Y.G
* */

class PostWidget extends StatelessWidget {
  final PostData postModel;
  const PostWidget({Key key, @required this.postModel}) : super(key: key);

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
              blurRadius: 1.0, // has the effect of softening the shadow
              offset: new Offset(1.0, 1.0),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Text(
                postModel.postBody,
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
              height: 8,
            ),
            _ReactionsButtons(),
            /*
            * The End of Reaction Buttons Row
            * */
            AddNewPostWidget("أكتب تعليقا ...", Colors.grey[300]),
          ],
        ),
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
    final PostData postData = InheritedPostModel.of(context).postData;

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
                    postData.authorName,
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
              width: 55,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: CircleAvatar(
                backgroundImage: postData.authorPhoto,
                backgroundColor: Colors.transparent,
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
    var timeTheme = new TextStyle( fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(postData.postTimeFormatted, style: timeTheme),
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
          bottom: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey[300],
                ),
              ),
            ),
            child: reactionsButtonRow(
                AssetImage("assets/images/share_icon.png"), 'مشاركة'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey[300],
                ),
              ),
            ),
            child: reactionsButtonRow(
                AssetImage("assets/images/comment.png"), 'تعليق'),
          ),
          reactionsButtonRow(
              AssetImage("assets/images/pray_icon.png"), 'آمين'),
        ],
      ),
    );
  }
}
