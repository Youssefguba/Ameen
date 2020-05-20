import 'dart:convert';
import 'dart:ui';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/services/post_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/or_line.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:toast/toast.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  var status;
  UserModel userModel;

  final logger = Logger();
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

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
                color: cGreen,
                fontSize: 13,
                fontFamily: 'Dubai',
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
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
        text: 'الإشتراك',
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
        EntryField("إسم المستخدم", Icon(Icons.person), editingController: userNameController),
        EntryField("البريد الإلكتروني", Icon(Icons.email),
            textInputType: TextInputType.emailAddress, editingController: emailController,),
        EntryField("إنشاء كلمة سر", Icon(Icons.lock),
            isPassword: true, visibleIcon: Icon(Icons.visibility_off), editingController: passwordController,),
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
              (_isLoading) ? Center(child: CircularProgressIndicator(
                backgroundColor: myColors.cBackground,
                valueColor: new AlwaysStoppedAnimation<Color>(myColors.cGreen),
              )): Container(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _title(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 10,
                    ),

                    //TODO => There is Button Here
                    SubmitButton(cGreen, "إنشاء حساب", createAccountButton),
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

                    //TODO => There is Button Here
                    SubmitButton(cFacebookColor,
                        "التسجيل بواسطة الفيسبوك", faceBookLoginButton),
                    SizedBox(
                      height: 13,
                    ),

                    //TODO => There is Button Here
                    SubmitButton(Colors.grey.shade700, "الدخول كمستخدم خفي", anonymousLoginButton)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Handle Normal Login Function */
  /// handle Response of Sign In and Compare tokens..
  signUp(UserModel userModel) async {
//    Map data = {'username': username, 'email': email, 'password': password};

    await http.post(PostsService.API + 'auth/signup', headers: PostsService.headers,
        body: json.encode(userModel.toJson())).then((data) {
      if(data.statusCode == 200 ) {
        var jsonResponse = json.decode(data.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          status = data.body.contains('error');
          if(status){
            print('data : ${jsonResponse["error"]}');
          }else {
            print('data : ${jsonResponse["token"]}');
            _save(jsonResponse["token"]);
          }

          // After Save the User redirect to Home Page.
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext buildContext) => Home()), (route) => false);
        }
      }

      /// If the Email is already exists
      else if (data.statusCode == 409) {
        setState(() {
          _isLoading = true;
        });
        Toast.show(
         'هذا الحساب موجود بالفعل',
          context,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_SHORT,
        );
        setState(() {
          _isLoading = false;
        });
      }

      /// If there is an Error in Internal Server.
      else if (data.statusCode == 500) {
        setState(() {
          _isLoading = true;
        });
        Toast.show(
          'حدث خطأ في التسجيل حاول مرة أخرى ',
          context,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG,
        );
        setState(() {
          _isLoading = false;
        });
      }
    });

  }

  /// Normal Login Button Function
  void  createAccountButton() {
    if(userNameController.text == '' || emailController.text == "" || passwordController.text == ''){
      Toast.show(
         'ارجوا عدم ترك الايميل الالكتروني او الرقم السري فارغا',
        context,
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
        gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_SHORT,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      var user = UserModel (
        userEmail: emailController.text,
        username: userNameController.text,
        password:  passwordController.text,
      );
      signUp(user);
    }
  }
  void faceBookLoginButton () {}

  void anonymousLoginButton() {}

}

//function save
_save(String token) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = token;
  prefs.setString(key, value);
}