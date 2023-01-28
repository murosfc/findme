import 'dart:io';

import 'package:findme/FindnMeHome.dart';
import 'package:findme/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localization/localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "email".i18n(),
                    labelStyle: const TextStyle(color: Colors.white70)),
                validator: (input) =>
                    !input!.contains('@') ? "email-valid".i18n() : null,
                onSaved: (input) => _email = input!,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
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
                    //Image.asset("../assets/google.png",aheight: 0.1, width: 0.1),
                    const SizedBox(width: 50),
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, String> body = {
        'email': _email,
        'password': _password,
      };
      String url = 'http://192.168.1.166:8080/user/login';
      String bodyJson = json.encode({'email': _email, 'password': _password});
      Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyJson);
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FindnMeHome()),
        );
      } else {
        if (response.statusCode == "Connection refused") {
          print("Error: ${response.statusCode}");
        }
      }
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
