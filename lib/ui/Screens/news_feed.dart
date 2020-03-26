import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/widgets/bottom_navigation.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/post_widgets/head_of_post.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/create_post_or_comment_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_button_row.dart';
import 'package:flutter/cupertino.dart';
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
      body: Container(
        child: ListView(
                children: <Widget>[
                  CreatePostOrComment("أنشر دعاء ...", Colors.grey[200]),
                  PostWidget(
                    name:"محمد أحمد" ,
                    time: "12:20",
                    image: AssetImage("assets/images/person_test.png"),
                    content: "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                  ),
                  PostWidget(
                    name:"محمد أحمد" ,
                    time: "12:20",
                    image: AssetImage("assets/images/person_test.png"),
                    content: "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                  ),
                  PostWidget(
                    name:"محمد أحمد" ,
                    time: "12:20",
                    image: AssetImage("assets/images/person_test.png"),
                    content: "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                  ),
                  PostWidget(
                    name:"محمد أحمد" ,
                    time: "12:20",
                    image: AssetImage("assets/images/person_test.png"),
                    content: "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                  ),




                ],
              ),
          ),
    );
  }

  /*
  * The Beginning of Post Widget (Photo, Name, Time, Setting, Reactions)..
  * */
//  Widget _postCard() {
//    return Container(
//      decoration: BoxDecoration(
//        color: Colors.white,
//        boxShadow: [
//          BoxShadow(
//            color: Colors.grey,
//            blurRadius: 1.0, // has the effect of softening the shadow
//            offset: new Offset(1.0, 1.0),
//          ),
//        ],
//      ),
//      margin: EdgeInsets.symmetric(vertical: 10),
//      child: Column(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 13),
//          ),
//
//          /*
//           * The top Section of Post (Photo, Time, Settings, Name)
//           * */
//          headOfPost(),
//
//          /*
//          * The Beginning of Text of the Post
//          * */
//          Container(
//            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//            padding: EdgeInsets.symmetric(horizontal: 13),
//            child: Text(
//              """اللهم إنك انت الحي القيوم لا إلة الا انت نستغفرك ونتوب إليك ونؤمن بك ونتوكل عليك انت الغني ونحن الفقراء إليك ، أنت القوي ونحن الضعفاء إليك  """,
//              style: TextStyle(
//                fontFamily: 'Dubai',
//                fontSize: 15,
//              ),
//              textDirection: TextDirection.rtl,
//            ),
//          ),
//          /*
//          * The End of Text of the Post
//          * */
//
//          /*
//          * The Beginning of Reaction Buttons Row
//          * */
//          SizedBox(
//            height: 8,
//          ),
//          Container(
//            width: MediaQuery.of(context).size.width,
//            decoration: BoxDecoration(
//              border: Border(
//                top: BorderSide(
//                  color: Colors.grey[300],
//                ),
//                bottom: BorderSide(
//                  color: Colors.grey[300],
//                ),
//              ),
//            ),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.symmetric(horizontal: 7.0),
//                  decoration: BoxDecoration(
//                    border: Border(
//                      right: BorderSide(
//                        color: Colors.grey[300],
//                      ),
//                    ),
//                  ),
//                  child: reactionsButtonRow(
//                      AssetImage("assets/images/share_icon.png"), 'مشاركة'),
//                ),
//                Container(
//                  padding: EdgeInsets.symmetric(horizontal: 7.0),
//                  decoration: BoxDecoration(
//                  border: Border(
//                    right: BorderSide(
//                      color: Colors.grey[300],
//                    ),
//                  ),
//                ),
//                child: reactionsButtonRow(
//                    AssetImage("assets/images/comment.png"), 'تعليق'),
//                ),
//                reactionsButtonRow(
//                    AssetImage("assets/images/pray_icon.png"), 'آمين'),
//              ],
//            ),
//          ),
//          /*
//          * The End of Reaction Buttons Row
//          * */
//
//          CreatePostOrComment("أكتب تعليقا ...", Colors.grey[300]),
//        ],
//      ),
//    );
//  }
}
