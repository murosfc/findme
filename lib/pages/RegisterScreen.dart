import 'dart:convert';

import 'package:findme/api/ApiUrls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localization/localization.dart';
import 'package:http/http.dart' as http;

import '../colors/VisualIdColors.dart';
import 'LoginPage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _familyName, _email, _password, _reenterPassword = "";
  bool _isLoading = false,
      _obscurePassword = true,
      _obscureReenterPassword = true;
  String? _errorMessage;
  final _emailTextEditingController = TextEditingController(),
      _passwordReenterTextEditingController = TextEditingController(),
      _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("register".i18n()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "name".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter-name".i18n();
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "surname".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSaved: (value) => _familyName = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _emailTextEditingController,
                decoration: InputDecoration(
                  labelText: 'email'.i18n(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter-email".i18n();
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
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
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "enter-password".i18n();
                  }
                  bool hasMinLength = value.length >= 8;
                  bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
                  bool hasDigits = value.contains(RegExp(r'[0-9]'));
                  bool hasSpecialCharacters =
                      value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                  String instructions = 'pass-rules'.i18n();
                  if (!hasMinLength) {
                    instructions += "\n- " + "pass-len".i18n();
                  }
                  if (!hasUpperCase) {
                    instructions += "\n- " + "pass-cap".i18n();
                  }
                  if (!hasDigits) {
                    instructions += "\n- " + "pass-num".i18n();
                  }
                  if (!hasSpecialCharacters) {
                    instructions += "\n- " + "pass-special".i18n();
                  }
                  return instructions;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordReenterTextEditingController,
                decoration: InputDecoration(
                  labelText: "reenter-password".i18n(),
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
                        _obscureReenterPassword = !_obscureReenterPassword;
                      });
                    },
                    icon: Icon(_obscureReenterPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                obscureText: _obscureReenterPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "reenter-password".i18n();
                  }
                  if (value != _password) {
                    return "pass-not-match".i18n();
                  }
                  return null;
                },
                onSaved: (value) => _reenterPassword = value!,
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
                      child: Text("register".i18n()),
                    ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true; // set isLoading state to true
    });

    Map<String, String> body = {
      'name': _name,
      'familyName': _familyName,
      'email': _email,
      'password': _password,
    };
    String bodyJson = json.encode(body);
    try {
      Response response = await http.post(Uri.parse(ApiUrls.registration),
          headers: {'Content-Type': 'application/json'}, body: bodyJson);
      if (response.statusCode == 200) {
        _showRegistrationSuccessPopup();
        // ignore: use_build_context_synchronously
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = "email-in-use".i18n();
          _passwordTextEditingController.clear();
          _emailTextEditingController.clear();
          _passwordReenterTextEditingController.clear();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "unknow-error".i18n();
        _passwordTextEditingController.clear();
        _passwordReenterTextEditingController.clear();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _errorMessage = null;
      });
    });
  }

  void _showRegistrationSuccessPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('register-sucess'.i18n()),
        content: Text('You have successfully registered.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
