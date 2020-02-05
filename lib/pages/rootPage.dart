import 'dart:core';

import 'package:agenda_app/model/authentication.dart';
import 'package:flutter/material.dart';
import 'signInPage.dart';
import 'listPage.dart';

//this root page it's gonna handle the login state
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});
  @override
  State<StatefulWidget> createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState((){
        if(user != null) {
          _userId = user?.uid;

        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  void logoutCallback() {
    setState((){
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }
  Widget waitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center, 
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('authStatus: $authStatus, userId: ${_userId.length}');
    if( authStatus == 'AuthStatus.LOGGED_IN' && _userId != Null){
        if(_userId.length > 0 && _userId != null) {
          print('_userId checked and valid');
          return ListPage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        }
    }
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED: 
      print('not determined');
        return waitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return SignInPage(
          auth: widget.auth,
          loginCallback:loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
      print('logged in');
          print('_userId checked and valid');
          return ListPage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        break;
        default: return waitingScreen();
    } 

  }
}
