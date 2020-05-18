import 'dart:convert';
import 'dart:ui';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/or_line.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ameen/helpers/ui/app_color.dart' as myColors;


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


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
                  fontFamily: 'Dubai',
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
                fontFamily: 'Dubai'),
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
                  fontFamily: 'Dubai',
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
                fontFamily: 'Dubai'),
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
          fontFamily: 'Dubai',
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryField("البريد الإلكتروني", Icon(Icons.email), textInputType: TextInputType.emailAddress, editingController: emailController),
        EntryField(" كلمة سر", Icon(Icons.lock), isPassword: true, visibleIcon: Icon(Icons.visibility_off), editingController: passwordController),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: _isLoading ? Center(child: RefreshProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(myColors.cGreen),
          )) : Container(
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

                SubmitButton(Color.fromRGBO(0, 153, 51, 1), "تسجيل الدخول", LoginButton),
                SizedBox(
                  height: 10,
                ),
                _createAccountLabel(),

                OrLine(),
                SizedBox(
                  height: 20,
                ),
                SubmitButton(Color.fromRGBO(59, 89, 152, 1),
                    "التسجيل بواسطة الفيسبوك", faceBookLoginButton),
                SizedBox(
                  height: 13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn(String email, password) async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': password};

    var jsonResponse = null;
    var response = await http.post(PostsService.API + 'auth/signin', body: data);
    if(response.statusCode == 200 ) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext buildContext) => Home()), (route) => false);
      }
    } else {
        setState(() {
          _isLoading = false;
        });
        print(response.body);
    }
  }

  void faceBookLoginButton() {}

  void  LoginButton() {
    if(emailController.text == "" || passwordController.text == ''){
      Fluttertoast.showToast(
        msg: 'ارجوا عدم ترك الايميل الالكتروني او ال الرقم السري فارغا',
        fontSize: 15,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      signIn(emailController.text, passwordController.text);
    }
  }

}

