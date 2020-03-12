import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  var color;
  var title;

  SubmitButton(this.color, this.title);

  @override
  Widget build(BuildContext context) {
    return _submitButton(color, title);
  }

  Widget _submitButton(Color color, String title) {
    return Center(
      child: Container(
        width: 170,
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
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
          title,
          style:
          TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold ),
        ),
      ),
    );
  }
}
