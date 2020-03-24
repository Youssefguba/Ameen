import 'package:ameen/helpers/ui/app_color.dart';
import 'package:flutter/material.dart';

/*
  *  Action Buttons Widgets like..
  *       (Like, Comment, Share)
  * */

Row reactionsButtonRow(ImageProvider image, String label) {
  return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(1.0),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
          child: Text(label,
              style: TextStyle(
                fontFamily: 'Dubai',
                fontSize: 13,
                color: cTextColor,
              )),
        ),
        Image(
          alignment: Alignment.center,
          image: image,
          width: 20,
          height: 20,
          color: Colors.black,
        ),
        VerticalDivider(width: 5.0, color: Colors.transparent, indent: 1.0),
      ],

  );
}
