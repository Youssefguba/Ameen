import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final color;
  final title;
  final GestureTapCallback gestureTapCallback;
  final Icon icon;
  SubmitButton({this.color, this.title, this.gestureTapCallback, this.icon});

  @override
  Widget build(BuildContext context) {
    return _submitButton(color, title);
  }

  Widget _submitButton(Color color, String title) {
    return Center(
      child: Container(
        width: 250,
        height: 50,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          shape: StadiumBorder(),
          color: color,
          disabledColor: color,
          splashColor: Colors.white,
          hoverColor: Colors.white,
          focusColor: Colors.white,
          highlightColor: Colors.grey.shade900.withOpacity(0.1),
          onPressed: gestureTapCallback,
          child: Text(
            title,
            style:
            TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Dubai', fontWeight: FontWeight.bold ),
          ),

        ),
      ),
    );
  }
}
