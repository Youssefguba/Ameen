import 'dart:ui';
import 'package:ameen/blocs/global/global.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/services/authentication.dart';
import 'package:ameen/ui/Screens/second_registeration.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/widgets/entry_field.dart';
import 'package:ameen/ui/widgets/or_line.dart';
import 'package:ameen/ui/widgets/submit_button.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  final CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = Logger();
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final AuthService auth = AuthService();

  FacebookLogin facebookLogin = FacebookLogin();
  
  UserModel currentUser;
  String username = '';
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool _obscureText = true;
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
          // Login Button Navigator
          InkWell(
            onTap: () {popPage(context);},
            child: Text(
              'تسجيل دخول',
              style: TextStyle(
                color: AppColors.cGreen,
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Username
          EntryField("إسم المستخدم", inputIcon: Icon(Icons.person),
              editingController: userNameController,
              onValueChanged: (value) => { username = value},
              validator: (val) => val.trim().length < 3 || val.isEmpty ? 'لا تترك خانة الإسم فارغة' : null,
          ),
          // Email Address
          EntryField(
            "البريد الإلكتروني",
            inputIcon: Icon(Icons.email),
              textInputType: TextInputType.emailAddress,
              editingController: emailController,
              onValueChanged: (value) => { email = value},
              validator: (val) => val.isEmpty ? 'لا تنسى كتابة الإيميل' : null,
          ),
          // Create a Password
          EntryField(
            "إنشاء كلمة سر",
            inputIcon: Icon(Icons.lock),
            isPassword: _obscureText,
            visibleIcon: IconButton(
                icon: (_obscureText)?Icon(Icons.visibility_off, color: Colors.grey):Icon(Icons.visibility, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }),
            editingController: passwordController, onValueChanged: (value) => { password = value},
            validator: (val) => val.length < 6  ? 'لا يمكن إدخال أقل من 6 ارقام أو حروف' : null,

          ),
        ],
      ),
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
                      child: SpinKitFadingCube(
                      color: AppColors.cGreen,
                        controller: AnimationController(duration: const Duration(milliseconds: 1200), vsync: this),
                      ))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _title(),
                          SizedBox(height: 20),
                          SizedBox(height: 10),
                          _emailPasswordWidget(),
                          SizedBox(height: 10),
                          SubmitButton(color: AppColors.cGreen, title: "إنشاء حساب", onTap: createAccount),
                          SizedBox(height: 10),
                          _loginAccountLabel(),
                          SizedBox(height: 10),
                          OrLine(),
                          SizedBox(height: 10),
                          SizedBox(height: 13),

                          // SignIn Anonymously Button
                          SubmitButton(color: Colors.grey.shade700,
                              title: "الدخول كمستخدم خفي", onTap: anonymousLoginButton)
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Normal Login Button Function
  void createAccount () async {
    if(_formKey.currentState.validate()) {
      setState(() => _isLoading = true );
      dynamic user = await auth.signUp(email, password);

      setState(() => _isLoading = false );
      if(user == null) {
        SnackBar snackBar = SnackBar(
          content: Text('هذا البريد الإلكتروني موجود بالفعل يرجى التأكد من البريد الإلكتروني مرة أخرى', style: TextStyle(fontFamily: 'Dubai')),
          backgroundColor: Colors.red.shade700,
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        usersRef.document(user.uid).setData({
          "id": user.uid,
          "username": username,
          "email": user.email,
          "joined_date": DateTime.now(),
        }); 
        GlobalVariable.currentUserId = user.uid;

        DocumentSnapshot doc = await usersRef.document(user.uid).get();
        doc = await usersRef.document(user.uid).get();
        currentUser = UserModel.fromDocument(doc);
        pushPage(context, SecondRegisteration());
      }
    }
  }

  // Anonymous Login Button Function
  void anonymousLoginButton() async {
    dynamic result = await auth.signInAnonymously();
    if (result == null) {
      SnackBar snackbar = SnackBar(content: Text("حدث خطأ في عملية التسجيل يرجى المحاولة مرة أخرى"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      SnackBar snackbar = SnackBar(content: Text("❤ 🤲🏻  مرحبا بك في تطبيق آمين"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}