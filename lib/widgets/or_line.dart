import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _orLine();
  }

  Widget _orLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        horizontalLine(),
        Text(
          'أو',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        horizontalLine(),
      ],
    );
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: 120,
      height: 1.0,
      color: Colors.grey.shade700,
    ),
  );
}
