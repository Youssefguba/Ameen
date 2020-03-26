import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/widgets/bottom_navigation.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/head_of_post.dart';
import 'package:ameen/ui/widgets/create_post_or_comment_widget.dart';
import 'package:ameen/ui/widgets/reactions_button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNavigation(1),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CreatePostOrComment("أنشر دعاء ...", Colors.grey[200]),
                  _postCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * The Beginning of Post Widget (Photo, Name, Time, Setting, Reactions)..
  * */
  Widget _postCard() {
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
          headOfPost(),

          /*
          * The Beginning of Text of the Post
          * */
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: Text(
              """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliq""",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 15,
              ),
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

          CreatePostOrComment("أكتب تعليقا ...", Colors.grey[300]),
        ],
      ),
    );
  }
}
