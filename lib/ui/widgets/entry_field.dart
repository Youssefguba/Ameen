import 'dart:ui';
import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String username;
  String title;
  Icon inputIcon;
  IconButton visibleIcon;
  bool isPassword;

  TextInputType textInputType;
  TextEditingController editingController;

  ValueChanged<String> onValueChanged;
  FormFieldValidator<String> validator;

  EntryField(this.title, this.inputIcon, {this.textInputType = TextInputType.text, this.isPassword = false
  , this.visibleIcon, this.editingController, this.onValueChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return _entryField(title, inputIcon, textInputType: textInputType, isPassword: isPassword , visibleIcon: visibleIcon);
  }

  Widget _entryField(String title, Icon inputIcon, {textInputType = TextInputType.text,
    bool isPassword = false, IconButton visibleIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
              validator: validator,
              onChanged: onValueChanged,
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
        ],
      ),
    );
  }
}
