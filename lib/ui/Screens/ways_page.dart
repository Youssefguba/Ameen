import 'package:ameen/blocs/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel>(context);

    if(currentUser == null) {

    }

  }
}
