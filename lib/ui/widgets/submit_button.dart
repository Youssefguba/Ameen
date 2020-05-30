import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';

class SubmitButton extends StatelessWidget {
  final color;
  final title;
  final GestureTapCallback gestureTapCallback;

  SubmitButton(this.color, this.title, this.gestureTapCallback);

  @override
  Widget build(BuildContext context) {
    return _submitButton(color, title);
  }

  Widget _submitButton(Color color, String title) {
    return Center(
      child: Container(
        width: 180,
        height: 50,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: StadiumBorder(),
          color: color,
          disabledColor: color,
          splashColor: Colors.white70,
          hoverColor: Colors.white70,
          focusColor: Colors.white70,
          highlightColor: MyColors.green[50],

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
