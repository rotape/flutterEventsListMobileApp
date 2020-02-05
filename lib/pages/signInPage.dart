import 'package:agenda_app/services/authService.dart';

import '../model/authentication.dart';
import 'package:flutter/material.dart';
class SignInPage extends StatefulWidget {
  SignInPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override 
  State<StatefulWidget> createState() => SignInPageState();
}
class SignInPageState extends State<SignInPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _email;
  String _password;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login to the CalendarApp'),),
      body: Stack(
        children: <Widget>[
          loginForm(),
          showProgress(),
        ]
      ),
    );
  }
  Widget loginForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showEmailInput(),
            showPasswordInput(),
            showButton(login, 'login'),
            showButton(register, 'register'),
          ],
        )
        )
    );
  }
  Widget showProgress() {
    if(_isLoading) {
      return Center(
        child: CircularProgressIndicator()
      );
    }
    return Container(
      height: 0,
      width: 0,
    );
  }

Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        controller: _emailController,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email required' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        controller: _passwordController,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showButton(action, text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35)
          ),
          color: Colors.blueGrey,
          child: Text( '$text',
            style: TextStyle(fontSize: 20, color: Colors.white),
          
          ),
          onPressed: action,
        )
      ),
    );
  

  }
  void register() {
    var userId = widget.auth.signUp(_emailController.text, _passwordController.text);
    if( userId !=null ) {
      widget.loginCallback();
    }
  }

  void login() {
    var userId = widget.auth.signIn(_emailController.text, _passwordController.text);
    if( userId !=null ) {
      widget.loginCallback();
    }
  }
}



