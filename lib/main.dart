import 'package:agenda_app/pages/addEventsPage.dart';
import 'package:agenda_app/pages/rootPage.dart';
import 'package:agenda_app/services/authService.dart';
import 'package:flutter/material.dart';
import 'pages/listPage.dart';
import 'pages/signInPage.dart';

//here we trigger the mainApp, everything hangs from it
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //to make it straight forward we'll be using material
    //here we set the main page and the routes
    return MaterialApp(
        title: 'Calendar App',
        home: RootPage(
          auth: AuthService(),
        ),
        routes: {
          '/List': (context) => ListPage(auth: AuthService()),
          '/AddEvents': (context) => AddEventsPage(),
          '/Signin': (context) => SignInPage(),
        });
  }
}
