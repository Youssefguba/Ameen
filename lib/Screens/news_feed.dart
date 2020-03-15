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
      backgroundColor: Colors.grey.shade200,
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
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 13),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: IconButton(
                  icon: Icon(Icons.more_horiz),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "محمد أحمد ",
                      style: TextStyle(
                        fontFamily: 'Dubai',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
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
        ],
      ),
    );
  }
}
