import 'dart:ui';
import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String title;
  final Icon inputIcon;
  TextInputType textInputType;
  bool isPassword;
  Icon visibleIcon;

  EntryField(this.title, this.inputIcon, {this.textInputType = TextInputType.text, this.isPassword = false
  , this.visibleIcon});

  @override
  Widget build(BuildContext context) {
    return _entryField(title, inputIcon, textInputType: textInputType, isPassword: isPassword , visibleIcon: visibleIcon );
  }

  Widget _entryField(String title, Icon inputIcon, {textInputType = TextInputType.text,
    bool isPassword = false, Icon visibleIcon}) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              obscureText: isPassword,
              autocorrect: true,
              keyboardType: textInputType,
              cursorColor:Color.fromRGBO(0, 153, 51, 1),
              style: TextStyle(fontFamily: 'Dubai', fontSize: 15),
              decoration: InputDecoration(
                suffixIcon: inputIcon,
                prefixIcon: visibleIcon,
                hintText: title,
                border: UnderlineInputBorder(),
              )),
        ],
      ),
    );
  }
}
