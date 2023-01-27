import 'package:findme/FindnMeHome.dart';
import 'package:findme/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../colors/VisualIdColors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _email, _password;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: "email".i18n(),
                    labelStyle: const TextStyle(color: Colors.white70)),
                validator: (input) =>
                    !input!.contains('@') ? "email-valid".i18n() : null,
                onSaved: (input) => _email = input!,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'password'.i18n(),
                    labelStyle: const TextStyle(color: Colors.white70)),
                validator: (input) =>
                    input!.length < 6 ? "password-valid".i18n() : null,
                onSaved: (input) => _password = input!,
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                onPressed: _submit,
                child: const Text('Login'),
                color: VisualIdColors.colorBlue(),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              const SizedBox(height: 15),
              MaterialButton(
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                onPressed: _handleSignIn,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //Image.asset("../assets/google.png", height: 10, width: 10),
                    //const SizedBox(width: 10),
                    Text("google-log".i18n()),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () => _register(),
                child: Text(
                  "register".i18n(),
                  style: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_email);
      print(_password);
      // Perform login here
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FindnMeHome()),
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
