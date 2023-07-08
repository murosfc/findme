import 'package:findme/api/ResponseStatusCode.dart';
import 'package:findme/pages/FindnMeHome.dart';

import 'package:findme/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../colors/VisualIdColors.dart';
import '../model/Notifications.dart';
import '../model/User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _email, _password;
  bool _isLoading = false, _obscurePassword = true;
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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "email".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (input) =>
                    !input!.contains('@') ? "valid-email".i18n() : null,
                onSaved: (input) => _email = input!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordTextEditingController,
                decoration: InputDecoration(
                  labelText: "password".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                  if (value!.isEmpty) {
                    return "enter-password".i18n();
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 15),
              _isLoading
                  ? const CircularProgressIndicator()
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
              const SizedBox(height: 15),
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

      int responseStatusCode = await User().login(_email, _password);

      if (responseStatusCode == ResponseStatusCode.SUCCESS) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FindnMeHome()),
        );
      } else if (responseStatusCode == ResponseStatusCode.BAD_CREDENTIALS) {
        _handleErrorMessage("invalid-credentials".i18n());
      } else {
        _handleErrorMessage("connection-error".i18n());
      }
    }
  }

  _handleErrorMessage(String message) {
    _errorMessage = message;
    setState(() {
      _isLoading = false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _errorMessage = null;
      });
    });
  }

  _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
