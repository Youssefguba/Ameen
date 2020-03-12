import 'dart:ui';
import 'package:ameen/widgets/entry_field.dart';
import 'package:ameen/widgets/or_line.dart';
import 'package:ameen/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: Text(
              'تسجيل دخول',
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
            'هل لديك حساب بالفعل ؟',
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
        text: 'الإشتراك',
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
        EntryField("الإسم", Icon(Icons.person)),
        EntryField("البريد الإلكتروني", Icon(Icons.email), textInputType: TextInputType.emailAddress),
        EntryField("إنشاء كلمة سر", Icon(Icons.lock), isPassword: true, visibleIcon: Icon(Icons.visibility_off)),
      ],
    );
  }

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
                    SizedBox(
                      height: 10,
                    ),
                    SubmitButton(Color.fromRGBO(0, 153, 51, 1), "إنشاء حساب"),
                    SizedBox(
                      height: 10,
                    ),
                    _loginAccountLabel(),
                    SizedBox(
                      height: 10,
                    ),
                    OrLine(),
                    SizedBox(
                      height: 10,
                    ),
                    SubmitButton(Color.fromRGBO(59, 89, 152, 1),
                        "التسجيل بواسطة الفيسبوك"),
                    SizedBox(
                      height: 13,
                    ),
                    SubmitButton(Colors.grey.shade700, "الدخول كمستخدم خفي")
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
