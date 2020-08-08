import 'dart:ui';
import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/sign_up.dart';
import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/localizations.dart';
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
  final TextEditingController resetEmailController =
      new TextEditingController();
  final AuthService auth = AuthService();
  FirebaseUser user;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  bool _obscureText = true;
  bool _isLoading = false;

  //Login Button
  void signIn() async {
    if (_formKey.currentState.validate()) {
      user = await auth.signIn(email, password);
      if (user == null) {
        SnackBar snackBar = SnackBar(
          content: Text(AppLocalizations.of(context).emailIsNotExist,
              style: TextStyle(fontFamily: 'Dubai')),
          backgroundColor: Colors.red.shade700,
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        currentUser = user;
        pushAndRemoveUntilPage(context, Home(currentUser: user));
      }
    }
  }

  _resetPasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context).resetYourPassword),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _resetEmailFormKey,
                  child: Column(
                    children: <Widget>[
                      EntryField(AppLocalizations.of(context).yourEmail,
                          inputIcon: Icon(Icons.email),
                          textInputType: TextInputType.emailAddress,
                          editingController: resetEmailController,
                          validator: (val) => val.isEmpty
                              ? AppLocalizations.of(context).emailCannotBeEmpty
                              : null),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text(AppLocalizations.of(context).resetYourPassword,
                        style: TextStyle(
                            fontFamily: 'Dubai', color: AppColors.cGreen)),
                    onPressed: () {
                      if (_resetEmailFormKey.currentState.validate()) {
                        _resetPassword();
                      }
                    },
                  ),
                  SimpleDialogOption(
                    child: Text(AppLocalizations.of(context).cancel,
                        style: TextStyle(
                            fontFamily: 'Dubai', color: Colors.black)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          );
        });
  }

  _resetPassword() async {
    dynamic userEmail =
        firebaseAuth.sendPasswordResetEmail(email: resetEmailController.text);
    if (userEmail == null) {
      SnackBar snackBar = SnackBar(
          content: Text(AppLocalizations.of(context).emailIsNotExist,
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
                      SubmitButton(
                          color: Color.fromRGBO(0, 153, 51, 1),
                          title: AppLocalizations.of(context).login,
                          onTap: signIn),
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
                AppLocalizations.of(context).createAccount,
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
            AppLocalizations.of(context).donotHaveAnAccount,
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
            onTap: () {
              _resetPasswordDialog(context);
            },
            child: Text(
              AppLocalizations.of(context).resetYourPassword,
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
            AppLocalizations.of(context).forgetPassword,
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
        text: AppLocalizations.of(context).login,
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
            AppLocalizations.of(context).yourEmail,
            inputIcon: Icon(Icons.email),
            textInputType: TextInputType.emailAddress,
            editingController: emailController,
            onValueChanged: (val) => email = val,
            validator: (val) => val.isEmpty
                ? AppLocalizations.of(context).emailCannotBeEmpty
                : null,
          ),
          EntryField(
            AppLocalizations.of(context).password,
            inputIcon: Icon(Icons.lock),
            isPassword: _obscureText,
            visibleIcon: IconButton(
                icon: (_obscureText)
                    ? Icon(Icons.visibility_off, color: Colors.grey)
                    : Icon(Icons.visibility, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }),
            editingController: passwordController,
            onValueChanged: (val) => password = val,
            validator: (val) => val.length < 6
                ? AppLocalizations.of(context).cannotPasswordSmallerThan
                : null,
          ),
        ],
      ),
    );
  }
}
