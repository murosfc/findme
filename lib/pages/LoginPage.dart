import 'package:findme/FindnMeHome.dart';
import 'package:findme/api/ApiUrls.dart';
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
  bool _isLoading = false,
      _obscurePassword = true,
      _obscureReenterPassword = true;
  String? _errorMessage;
  final _passwordTextEditingController = TextEditingController();

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
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordTextEditingController,
                decoration: InputDecoration(
                  labelText: "password".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    color: Colors.white70,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  value!.length < 8 ? "password-valid".i18n() : null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 15),
              _isLoading
                  ? CircularProgressIndicator()
                  : MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _submit();
                        }
                      },
                      color: VisualIdColors.colorBlue(),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: const Text("Login"),
                    ),
              InkWell(
                onTap: () => _register(),
                child: Text(
                  "register".i18n(),
                  style: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      Map<String, String> body = {
        'email': _email,
        'password': _password,
      };
      String bodyJson = json.encode({
        'email': _email,
        'password': _password,
      });
      Response response = await http.post(Uri.parse(ApiUrls.loginUrl()),
          headers: {'Content-Type': 'application/json'}, body: bodyJson);
      if (response.statusCode == 200) {
        //User.storeCredentials(response);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FindnMeHome()),
        );
      } else if (response.statusCode == 401) {
        _errorMessage = "invalid-credentials".i18n();
      }
      setState(() {
        _isLoading = false;
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _errorMessage = null;
        });
      });
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
