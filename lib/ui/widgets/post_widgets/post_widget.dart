import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';

/*
* This class represent the UI of Post and every thing related with it..
* Y.G
* */
class PostWidget extends StatefulWidget {
  final String name;
  final String time;
  final ImageProvider image;
  final String content;

  const PostWidget({this.name, this.time, this.image, this.content});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          headOfPost(widget.name,widget.time,widget.image),

          /*
          * The Beginning of Text of the Post
          * */
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: Text(
              widget.content,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }

  /*
  * The top Section of Post (Photo, Time, Settings, Name)
  * */
  Row headOfPost(String name, String time, ImageProvider image){
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
                  margin:
                  EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    time,
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
              height: 50,
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Image(
                image: image,
//                AssetImage('assets/images/person_test.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
