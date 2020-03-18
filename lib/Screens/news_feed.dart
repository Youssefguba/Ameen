import 'package:ameen/widgets/bottom_navigation.dart';
import 'package:ameen/widgets/custom_app_bar.dart';
import 'package:ameen/widgets/post_card.dart';
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
      backgroundColor: Color.fromRGBO(222, 222, 222, 1),
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNavigation(),
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
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 0.5, // has the effect of softening the shadow
            offset: new Offset(0.5, 0.5),
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
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Image(
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

            child: Text(""" glsjdflgksfdkjgnsdkfjgnksjfdgjskdfhgkjsdhgjhsdfgjhsdkjfghkjsdfhgkjsdfhgkjsdhfgkjsdhfgkjshdfgijlshdf"""
          ,style: TextStyle(
              fontFamily: 'Dubai',
              fontSize: 15,
            ),
          ),
          ),
        ],
      ),
    );
  }
}
