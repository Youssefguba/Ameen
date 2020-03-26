import 'package:ameen/blocs/models/choice.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/Screens/create_post.dart';
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

  Widget _addDoaaButton(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePost(),
          ),
        );
      },
      color: myColors.green[900],
      padding: EdgeInsets.all(5),
      elevation: 1.0,
      hoverColor: Colors.white,
      textColor: Colors.white,
      disabledColor: myColors.green,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
      animationDuration: Duration(seconds: 2),
      child: Text(
        "إضافة دعاء +",
        style:
            TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Dubai'),
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
  Widget _horizontalLine() => Container(
        height: 1.0,
        margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.grey.shade300,
      );
}
