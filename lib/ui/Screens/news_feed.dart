import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/widgets/bottom_navigation.dart';
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/post_card.dart';
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
                  CreatePost(),
                  _postCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        children: <Widget>[
          Row(
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
                          "محمد أحمد ",
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
                          "منذ 5 دقائق ",
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
                      image: AssetImage('assets/images/person_test.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(
              """ glsjdflgksfdkjgnsdkfjgnksjfdgjskdfhgkjsdhgjhsdfgjhsdkjfghkjsdfhgkjsdfhgkjsdhfgkjsdhfgkjshdfgijlshdf""",
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[400],
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                child: Text("مشاركة"),
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  child: Text("تعليق"),
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  child: Text("آمين"),
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
