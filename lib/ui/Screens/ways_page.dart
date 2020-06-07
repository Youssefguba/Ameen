import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/ui/Screens/login.dart';
import 'package:ameen/ui/Screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaysPage extends StatefulWidget {
  @override
  _WaysPageState createState() => _WaysPageState();
}

class _WaysPageState extends State<WaysPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel>(context);
    if(currentUser == null) {
      return Login();
    } else {
      return SettingsPage();
    }
  }
}
