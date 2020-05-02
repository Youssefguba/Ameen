import 'package:ameen/blocs/models/post.dart';
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
      postModel: postModel,
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
            headOfPost(postModel.authorName, postModel.postTime, postModel.authorPhoto),

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
            Container(
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
            ),
            /*
          * The End of Reaction Buttons Row
          * */

            AddNewPostWidget("أكتب تعليقا ...", Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  /*
  * The top Section of Post (Photo, Time, Settings, Name)
  * */
  Row headOfPost(String name, DateTime createdAt, ImageProvider image) {
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
                    name,
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    createdAt.toString(),
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 55,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: CircleAvatar(
                backgroundImage: image,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//class _UserImage extends StatelessWidget {
//  const _UserImage({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final Post postData = InheritedPostModel.of(context).postModel;
//    return Expanded(
//      flex: 1,
//      child: CircleAvatar(backgroundImage: AssetImage(postData.authorPhoto)),
//    );
//  }
//}
//
//class _PostTimeStamp extends StatelessWidget {
//  const _PostTimeStamp({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Expanded(
//      flex: 2,
//      child: Text(postData.createdAt.toString()),
//    );
//  }
//}
