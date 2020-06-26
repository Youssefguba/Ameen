import 'dart:ui';
import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/sign_up.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ameencommon/utils/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _resetEmailFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController resetEmailController = new TextEditingController();
  final AuthService auth = AuthService();
  FirebaseUser user;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  String email = '';
  String password = '';
  bool _obscureText = true;
  bool _isLoading = false;

  //Login Button
  void signIn() async {
    if(_formKey.currentState.validate()) {
      user = await auth.signIn(email, password);
      print('This is a result of login ${user.toString()}');
      if(user == null) {
        SnackBar snackBar = SnackBar(
          content: Text('حدث خطأ في تسجيل الدخول برجاء التأكد من البريد الالكتروني وكلمة السر', style: TextStyle(fontFamily: 'Dubai')),
          backgroundColor: Colors.red.shade700,
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        currentUser = user;
        pushAndRemoveUntilPage(context, Home(currentUser: user,));
      }
    }
  }

   _resetPasswordDialog(BuildContext context) {
     return showDialog(
         context: context,
         builder: (context) {
           return SimpleDialog(
             title: Text("إسترجاع كلمة السر"),
             children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _resetEmailFormKey,
                    child: Column(
                      children: <Widget>[
                        EntryField('اكتب الإيميل الالكتروني الخاص بك',
                          inputIcon: Icon(Icons.email),
                          textInputType: TextInputType.emailAddress,
                          editingController: resetEmailController,
                          validator: (val) => val.isEmpty ? 'لا يمكن ترك الإيميل الالكتروني فارغا' : null ),
                      ],
                    ),
                  ),
                ),
               Row(
                 children: <Widget>[
                   SimpleDialogOption(
                     child: Text('إسترجاع كلمة السر', style: TextStyle(fontFamily: 'Dubai', color:AppColors.cGreen)),
                     onPressed: () {
                       if(_resetEmailFormKey.currentState.validate()){
                         _resetPassword();
                       }},
                   ),

                   SimpleDialogOption(
                     child: Text('إلغاء', style: TextStyle(fontFamily: 'Dubai', color: Colors.black)),
                     onPressed: () => Navigator.pop(context) ,
                   ),
                 ],
               ),
             ],
           );
         });
  }

  _resetPassword() async {
    dynamic userEmail = firebaseAuth.sendPasswordResetEmail(email: resetEmailController.text);
    if(userEmail == null) {
      SnackBar snackBar = SnackBar(
        content: Text('هذا الإيميل غير موجود',
          style: TextStyle(fontFamily: 'Dubai', color: Colors.white)),
        backgroundColor: Colors.red.shade500,
        duration: Duration(seconds: 3));
      _scaffoldKey.currentState.showSnackBar(snackBar);
  } else {
      SnackBar snackBar = SnackBar(
          content: Text('تم الإرسال',
              style: TextStyle(fontFamily: 'Dubai', color: Colors.white)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: _isLoading
              ? Center(
                  child: RefreshProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(AppColors.cGreen),
                ))
              : Container(
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
                      SubmitButton(color: Color.fromRGBO(0, 153, 51, 1),
                          title: "تسجيل الدخول", onTap: signIn),
                      SizedBox(
                        height: 10,
                      ),
                      _createAccountLabel(),
//                      OrLine(),
//                      SizedBox(
//                        height: 20,
//                      ),
//                      SubmitButton(Color.fromRGBO(59, 89, 152, 1),
//                          "التسجيل بواسطة الفيسبوك", faceBookLoginButton),
//                      SizedBox(
//                        height: 13,
//                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
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
                    fontFamily: 'Dubai',
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {
                pushPage(context, SignUp());
              }),
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
            onTap: () {_resetPasswordDialog(context);},
            child:
            Text(
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          EntryField(
            "البريد الإلكتروني",
            inputIcon: Icon(Icons.email),
            textInputType: TextInputType.emailAddress,
            editingController: emailController,
            onValueChanged: (val) => email = val,
            validator: (val) => val.isEmpty ? 'لا يمكن ترك البريد اللألكتروني فارغا' : null,
          ),
          EntryField(
            " كلمة سر",
            inputIcon: Icon(Icons.lock),
            isPassword: _obscureText,
            visibleIcon: IconButton(
              icon: (_obscureText)?Icon(Icons.visibility_off, color: Colors.grey):Icon(Icons.visibility, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }),
            editingController: passwordController,
            onValueChanged: (val) => password = val,
            validator: (val) =>
            val.length < 6 ? 'لا يمكن إدخال أقل من 6 ارقام أو حروف' : null,
          ),
        ],
      ),
    );
  }


}
