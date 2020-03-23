import 'package:ameen/helpers/ui/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1.0),
            blurRadius: 1.0, // has the effect of softening the shadow
            offset: new Offset(1.0, 1.0),
          ),
        ],
      ),
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
          Image(
            image: AssetImage('assets/images/person_test.png'),
            height: 62,
            width: 62,
          ),
        ],
      ),
    );
  }
}
