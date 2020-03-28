import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            onPressed: (){
              Navigator.pop(context);
            },
            icon: ImageIcon(
            AssetImage("assets/images/arrow_back.png"),
            size: 20,
              color: Colors.black,
          ),),

        ],
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          child: TextField(
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLength: 220,
            maxLines: 9,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Dubai'
            ),
            textInputAction: TextInputAction.newline,
            autofocus: true,
            showCursor: true,
            maxLengthEnforced: true,
            expands: false,
            minLines: 1,
            scrollPhysics:  BouncingScrollPhysics(),
            cursorColor: myColors.green[900],
            decoration: InputDecoration(
              contentPadding:  EdgeInsets.all(15.0),
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
