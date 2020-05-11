import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/widgets/post_widgets/fb_reaction_box.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReactionsButtonRow extends StatelessWidget {
  Image image;
  Text label;
  ReactionsButtonRow({this.image, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.0),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
            child: label,
          ),
          image,
          VerticalDivider(width: 5.0, color: Colors.transparent, indent: 1.0),
        ],
      ),
    );
  }
}

/*
  *  Action Buttons Widgets like..
  *       (Like, Comment, Share)
  * */

class ReactionsButtons extends StatefulWidget {
  @override
  _ReactionsButtonsState createState() => _ReactionsButtonsState();
}

class _ReactionsButtonsState extends State<ReactionsButtons> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ReactionsButtonRow(
            image: Image.asset("assets/images/share_icon.png",
                width: 20, height: 20),
            label: Text("مشاركة",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: myColors.cTextColor,
                )),
          ),
          ReactionsButtonRow(
            image:
                Image.asset("assets/images/comment.png", width: 20, height: 20),
            label: Text("تعليق",
                style: TextStyle(
                  fontFamily: 'Dubai',
                  fontSize: 13,
                  color: myColors.cTextColor,
                )),
          ),
          InkWell(
            child: FlatButton(
              child: ReactionsButtonRow(
                image: Image.asset("assets/images/pray_icon.png",
                    color: (isPressed) ? myColors.cGreen : myColors.cTextColor,
                    width: 20,
                    height: 20),
                label: Text("آمين",
                    style: TextStyle(
                      fontFamily: 'Dubai',
                      fontSize: 13,
                      color:
                          (isPressed) ? myColors.cGreen : myColors.cTextColor,
                      fontWeight:
                          (isPressed) ? FontWeight.w600 : FontWeight.normal,
                    )),
              ),
            ),
            onTap: () {
              if (!isPressed) {
                setState(() {
                  isPressed = true;
                });
              } else {
                setState(() {
                  isPressed = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
