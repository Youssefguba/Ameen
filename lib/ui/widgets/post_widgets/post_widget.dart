import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;


/*
* This class represent the UI of Post and every thing related with it..
* Y.G
* */

class PostWidget extends StatelessWidget {
  final PostData postModel;
//  final PostDetails postDetails;
  const PostWidget({Key key, this.postModel}) : super(key: key);

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
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                postModel.body,
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
            ReactionsButtons(),
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
    final PostData postData = InheritedPostModel.of(context).postData;
    var timeTheme = new TextStyle( fontFamily: 'Dubai', fontSize: 13, color: Colors.grey.shade500);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Text(postData.postTimeFormatted, style: timeTheme),
    );
  }
}
