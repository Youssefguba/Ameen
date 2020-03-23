import 'package:ameen/blocs/models/choice.dart';
import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/widgets/choice_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final double appBarHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/person_test.png',
              width: 100.0,
              height: 100.0,
            ),
            Container(
              child: Text(
                "محمد أحمد ",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Dubai',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _followersAndFollowingRow(),
            _addDoaaButton(context),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addDoaaButton(BuildContext buildContext) {
    return Center(
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cGreen,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: Text(
          "إضافة دعاء +",
          style:
              TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
        ),
      ),
    );
  }

  Widget _followersAndFollowingRow() {
    return Container(
      padding: EdgeInsets.all(13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              "50 متابعين      ",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Dubai',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "50 متابعاً      ",
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'Dubai',
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  // The Line that divide between Add Doaa and Posts and Saved Doaa..
  Widget _horizontalLine() =>
     Container(
      height: 1.0,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey.shade300,
  );

}


