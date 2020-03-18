import 'package:flutter/material.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                showCursor: false,
                style:
                TextStyle(fontFamily: 'Dubai', fontSize: 14, height: 1.0),
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "..  أنشر دعاء ",
                  contentPadding: EdgeInsets.all(20.0),
                  enabled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                )),
          ),
          IconButton(
            icon: Icon(Icons.person_pin),
            iconSize: 35.0,
            disabledColor: Color.fromRGBO(62, 146, 42, 1),
          ),
        ],
      ),
    );
  }
}

