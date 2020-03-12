import 'dart:ui';
import 'package:ameen/widgets/entry_field.dart';
import 'package:ameen/widgets/or_line.dart';
import 'package:ameen/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

Widget _createAccountLabel() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          child: Text(
            'إنشاء حساب',
            style: TextStyle(
                color: Color.fromRGBO(0, 153, 51, 1),
                fontSize: 13,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          " ليس لديك حساب على آمين ؟",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              fontFamily: 'Cairo'),
        ),
      ],
    ),
  );
}

Widget _forgetPassword() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          child: Text(
            'إسترجاع كلمة السر',
            style: TextStyle(
                color: Color.fromRGBO(0, 153, 51, 1),
                fontSize: 13,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          'هل نسيت كلمة السر ؟',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              fontFamily: 'Cairo'),
        ),
      ],
    ),
  );
}

Widget _title() {
  return RichText(
    textAlign: TextAlign.right,
    text: TextSpan(
      text: 'تسجيل الدخول',
      style: TextStyle(
        fontSize: 25,
        fontFamily: 'Cairo',
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade700,
      ),
    ),
  );
}

Widget _emailPasswordWidget() {
  return Column(
    children: <Widget>[
      EntryField("البريد الإلكتروني", Icon(Icons.email), textInputType: TextInputType.emailAddress),
      EntryField(" كلمة سر", Icon(Icons.lock), isPassword: true, visibleIcon: Icon(Icons.visibility_off)),
    ],
  );
}


class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    _title(),
                    SizedBox(
                      height: 10,
                    ),
                    _emailPasswordWidget(),
                    _forgetPassword(),

                    SubmitButton(Color.fromRGBO(0, 153, 51, 1), "تسجيل الدخول"),
                    SizedBox(
                      height: 10,
                    ),
                    _createAccountLabel(),

                    OrLine(),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitButton(Color.fromRGBO(59, 89, 152, 1),
                        "التسجيل بواسطة الفيسبوك"),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
