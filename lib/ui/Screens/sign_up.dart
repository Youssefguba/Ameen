import 'dart:convert';
import 'dart:ui';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/services/authentication.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/or_line.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final logger = Logger();

  AuthService auth = AuthService();
  UserModel userModel;

  bool _isLoading = false;
  var status;

  @override
  void dispose() {
    super.dispose();
  }

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
                color: MyColors.cGreen,
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
        EntryField("إسم المستخدم", Icon(Icons.person),
            editingController: userNameController),
        EntryField(
          "البريد الإلكتروني",
          Icon(Icons.email),
          textInputType: TextInputType.emailAddress,
          editingController: emailController,
        ),
        EntryField(
          "إنشاء كلمة سر",
          Icon(Icons.lock),
          isPassword: true,
          visibleIcon: Icon(Icons.visibility_off),
          editingController: passwordController,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              (_isLoading)
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: MyColors.cBackground,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
                    ))
                  : Container(
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
                          SubmitButton(MyColors.cGreen, "إنشاء حساب",
                              createAccountButton),
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

                          SubmitButton(MyColors.cFacebookColor,
                              "التسجيل بواسطة الفيسبوك", faceBookLoginButton),
                          SizedBox(
                            height: 13,
                          ),

                          // SignIn Anonymously Button
                          SubmitButton(Colors.grey.shade700,
                              "الدخول كمستخدم خفي", anonymousLoginButton)
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
    await http
        .post(Api.API + 'auth/signup',
            headers: Api.headers, body: json.encode(userModel.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        var jsonResponse = json.decode(data.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          status = data.body.contains('error');
          if (status) {
            print('data : ${jsonResponse["error"]}');
          } else {
            print('data : ${jsonResponse["token"]}');
            _save(jsonResponse["token"]);
//            _save(jsonResponse["token"]);
          }

          // After Save the User redirect to Home Page.
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext buildContext) => Home()),
              (route) => false);
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
  void createAccountButton() {
    if (userNameController.text == '' ||
        emailController.text == "" ||
        passwordController.text == '') {
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
      var emailText = emailController.text;
      var usernameText = userNameController.text;
      var passwordText = passwordController.text;

      var user = UserModel(
        userEmail: emailText.trim().trimRight().trimLeft(),
        username: usernameText.trim().trimRight().trimLeft(),
        password: passwordText.trim().trimRight().trimLeft(),
      );
      signUp(user);
    }
  }

  /// Facebook Login Button Function
  void faceBookLoginButton() {}

  /// Anonymous Login Button Function
  void anonymousLoginButton() async {
    dynamic result = await auth.signInAnonymously();
    if (result == null) {
      SnackBar snackbar = SnackBar(content: Text("حدث خطأ في عملية التسجيل يرجى المحاولة مرة أخرى"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      SnackBar snackbar = SnackBar(content: Text("❤ 🤲🏻  مرحبا بك في تطبيق آمين"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      print(result);
    }
  }
}

//function save
_save(String token) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = token;
  prefs.setString(key, value);
}
