import 'package:ameencommon/localizations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityCheck extends StatelessWidget {
  final Widget child;

  ConnectivityCheck({this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == ConnectivityResult.none) {
            return Center(
              child: Text(AppLocalizations.of(context).noInternet),
            );
          } else {
            return child;
          }
        });
  }
}