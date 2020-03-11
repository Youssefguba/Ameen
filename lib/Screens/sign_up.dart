import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key, this.title}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
  final String title;
}

class _SignUpState extends State<SignUp> {
  Widget _entryField(String title, Icon inputIcon, {textInputType = TextInputType.text, bool isPassword = false,
  Icon visibleIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          TextField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              obscureText: isPassword,
              autocorrect: true,
              keyboardType: textInputType,
              cursorColor:Color.fromRGBO(0, 153, 51, 1),
              style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
              decoration: InputDecoration(
                suffixIcon: inputIcon,
                prefixIcon: visibleIcon,
                hintText: title,
                border: UnderlineInputBorder(),
              ))
        ],
      ),
    );
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

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
//      alignment: Alignment.bottomCenter,
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
        _entryField("الإسم", Icon(Icons.person)),
        _entryField("البريد الإلكتروني", Icon(Icons.email), textInputType: TextInputType.emailAddress),
        _entryField("إنشاء كلمة سر", Icon(Icons.lock), isPassword: true, visibleIcon: Icon(Icons.visibility_off)),
      ],
    );
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
                    _submitButton(Color.fromRGBO(0, 153, 51, 1), "إنشاء حساب"),
                    SizedBox(
                      height: 10,
                    ),
                    _loginAccountLabel(),
                    SizedBox(
                      height: 10,
                    ),
                    _orLine(),
                    SizedBox(
                      height: 10,
                    ),
                    _submitButton(Color.fromRGBO(59, 89, 152, 1),
                        "التسجيل بواسطة الفيسبوك"),
                    SizedBox(
                      height: 13,
                    ),
                    _submitButton(Colors.grey.shade700, "الدخول كمستخدم خفي")
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
