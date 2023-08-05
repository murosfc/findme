import 'dart:async';

import 'package:findme/model/User.dart';
import 'package:findme/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'FindnMeHome.dart';

import 'package:permission_handler/permission_handler.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      // Request camera permission
      await Permission.camera.request();
    }

    // Check location permission
    var locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      // Request location permission
      await Permission.location.request();
    }

    // Check if all permissions have been granted
    if (await Permission.camera.isGranted &&
        await Permission.location.isGranted) {
      // All permissions have been granted, proceed to next screen
      _checkIsUserLogged();
    } else {
      // Not all permissions have been granted, show a message to the user
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("permissions-required-alert".i18n()),
            content: Text("permissions-required-message".i18n()),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _checkIsUserLogged() async {
    User user = User();
    bool isUserLogged = await user.isUserLogged();
    if (isUserLogged) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FindnMeHome()),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: Center(
        child: FadeTransition(
          opacity: _animationController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20.0),
              Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
