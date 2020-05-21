import 'package:ameen/blocs/models/insert_post.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/news_feed.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:get_it/get_it.dart';
import 'package:toast/toast.dart';

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
//      bottomNavigationBar:
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
        height: double.maxFinite,
        margin: EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            // TextField of Post
            TextField(
              controller: _postBodyController,
              textAlign: TextAlign.right,
              maxLength: 220,
              maxLines: 9,
              style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              textInputAction: TextInputAction.newline,
              autofocus: true,
              showCursor: true,
              maxLengthEnforced: false,
              expands: false,
              minLines: 1,
              scrollController: ScrollController(),
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

            // Post Button
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                widthFactor: double.maxFinite,
                child: FlatButton(

                  focusColor: myColors.cBackground,
                  hoverColor: myColors.cBackground,
                  onPressed: createAPost,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createAPost() async {
    // Get the Post body from the TextField of the text..
    final post = PostInsert(
          postBody: _postBodyController.text);

      // Check if the text field is empty or not.
      if(_postBodyController.text.isEmpty) {
        Toast.show(
            'لا يجب ترك المنشور فارغا',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.red.shade800
        );
      } else {
        // Check if the post is created or not..
        await services.createPost(post).then((result) {
          if (result.data == true) {
            Navigator.of(context).pop(NewsFeed);
            Toast.show(
              'تم نشر الدعاء بنجاح',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          } else {
            Navigator.of(context).pop(NewsFeed);
            Toast.show(
              'حدث خلل في نشر الدعاء حاول مرة أخرى',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          }
        });
      }
    }
  }

