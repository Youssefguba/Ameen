import 'package:ameen/blocs/models/post_data.dart';
import 'package:flutter/cupertino.dart';

class DemoValues {

  static final List<PostData> posts = [
    PostData(
    postId: "1" ,
    postBody: "Hello Every One",
    authorName : "Youssef Ahmed",
    authorPhoto : AssetImage('assets/images/person_test.png'),
    postTime : DateTime(2017, 6, 30),
    ),
    PostData(
    postId: "2" ,
    postBody: "Hello Every One",
    authorName : "Youssef Ahmed",
    authorPhoto : AssetImage('assets/images/person_test.png'),
    postTime : DateTime(2017, 6, 30),
    ),
    PostData(
    postId: "3" ,
    postBody: "Hello Every One",
    authorName : "Youssef Ahmed",
    authorPhoto : AssetImage('assets/images/person_test.png'),
      postTime : DateTime(2017, 6, 30),
    ),
    PostData(
    postId: "4" ,
    postBody: "Hello Every One",
    authorName : "Youssef Ahmed",
    authorPhoto : AssetImage('assets/images/person_test.png'),
      postTime : DateTime(2017, 6, 30),
    ),
  ];
}