import 'dart:ui';
import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String username;

  final String title;
  final Icon inputIcon;
  TextInputType textInputType;
  bool isPassword;
  Icon visibleIcon;
  TextEditingController editingController;

  EntryField(this.title, this.inputIcon, {this.textInputType = TextInputType.text, this.isPassword = false
  , this.visibleIcon, this.editingController});

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
          Form(
          key: _formKey,
            child: TextFormField(
                controller: editingController,
                textAlign: TextAlign.right,
                obscureText: isPassword,
                keyboardType: textInputType,
                cursorColor:Color.fromRGBO(0, 153, 51, 1),
                style: TextStyle(fontFamily: 'Dubai', fontSize: 15),
                decoration: InputDecoration(
                  suffixIcon: inputIcon,
                  prefixIcon: visibleIcon,
                  hintText: title,
                  border: UnderlineInputBorder(),
                )),
          ),
        ],
      ),
    );
  }
}
