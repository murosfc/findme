import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _password, _reenterPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("register".i18n()),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: "name".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70)),
              validator: (value) {
                if (value!.isEmpty) {
                  return "enter-name".i18n();
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'email'.i18n(),
                  labelStyle: const TextStyle(color: Colors.white70)),
              validator: (value) {
                if (value!.isEmpty) {
                  return "enter-email".i18n();
                }
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "password".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70)),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "enter-password".i18n();
                }
                return null;
              },
              onSaved: (value) => _password = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "reenter-password".i18n(),
                  labelStyle: const TextStyle(color: Colors.white70)),
              obscureText: true,
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
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  //TODO: Save the user's information and navigate to the next screen
                }
              },
              child: Text("register".i18n()),
            ),
          ],
        ),
      ),
    );
  }
}
