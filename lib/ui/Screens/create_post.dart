import 'package:ameen/blocs/models/insert_post.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:get_it/get_it.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  PostsService get services => GetIt.I<PostsService>();

  TextEditingController _postBodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: FlatButton(
        autofocus: true,
        focusColor: myColors.cBackground,
        hoverColor: myColors.cBackground,
        onPressed: () async {
          final post = PostInsert(
              // Get the Post body from the TextField of the text..
                postBody: _postBodyController.text);

          final result = await services.createPost(post);
          Navigator.of(context).pop();
          final text = result.error
              ? (result.errorMessage ?? 'حدث خلل ما ')
              : 'تم نشر الدعاء بنجاح ❤';
          //To pop from the page after published of post.
          if (result.data) {
            Navigator.of(context).pop(NewsFeed);
          }

        },
        padding: EdgeInsets.symmetric(vertical: 10),
        color: myColors.cGreen,
        disabledColor: myColors.cGreen,
        child: Text(
          "نشر الدعاء",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          "أكتب دعاء ",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Dubai',
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ImageIcon(
              AssetImage("assets/images/arrow_back.png"),
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: TextField(
          controller: _postBodyController,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLength: 220,
          maxLines: 9,
          style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
          textInputAction: TextInputAction.newline,
          autofocus: true,
          showCursor: true,
          maxLengthEnforced: true,
          expands: false,
          minLines: 1,
          scrollPhysics: BouncingScrollPhysics(),
          cursorColor: myColors.green[900],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: InputBorder.none,
            hintText: " ... أكتب الدعاء الذي يجول بخاطرك ",
            hintStyle: TextStyle(
              fontFamily: 'Dubai',
            ),
          ),
        ),
      ),
    );
  }
}
