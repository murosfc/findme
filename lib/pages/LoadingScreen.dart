import 'dart:async';

import 'package:findme/model/User.dart';
import 'package:findme/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'FindnMeHome.dart';
import '../services/permission_service.dart';
import '../constants/app_constants.dart';

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
      duration: AppConstants.animationDuration,
    )..repeat();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final allPermissionsGranted = await PermissionService.requestAndCheckPermissions();

    if (allPermissionsGranted) {
      await _checkIsUserLogged();
    } else {
      _showPermissionsDialog();
    }
  }

  void _showPermissionsDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("permissions-required-alert".i18n()),
          content: Text("permissions-required-message".i18n()),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkIsUserLogged() async {
    if (!mounted) return;
    
    final user = User();
    final isUserLogged = await user.isUserLogged();
    
    if (!mounted) return;
    
    final nextPage = isUserLogged ? FindnMeHome() : LoginPage();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
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
                "Carregando...",
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
