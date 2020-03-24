import 'package:flutter/material.dart';

/*
  * The top Section of Post (Photo, Time, Settings, Name)
  * */
Row headOfPost(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Flexible(
        child: IconButton(
          icon: Icon(Icons.more_horiz),
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 5, 1),
                child: Text(
                  "محمد أحمد ",
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin:
                EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                child: Text(
                  "منذ 5 دقائق ",
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Image(
              image: AssetImage('assets/images/person_test.png'),
            ),
          ),
        ],
      ),
    ],
  );
}