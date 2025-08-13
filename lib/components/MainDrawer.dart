import 'package:findme/colors/VisualIdColors.dart';
import 'package:findme/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

import '../model/User.dart';
import '../pages/RegisterScreen.dart';
import 'AddContact.dart';

class MainDrawer extends StatelessWidget {   
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {   
    return Container(
      color: VisualIdColors.colorGreen(),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20.0),
          _buildFavoritesItem(),
          _buildOngoingSessionItem(),
          _buildSettingsItem(),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: VisualIdColors.colorGreen(),
      child: const Padding(
        padding: EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Menu",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),                   
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesItem() {
    return ListTile(
      onTap: () {},
      leading: const Icon(
        Icons.star_border,
        color: Colors.white70,
      ),
      title: Text(
        "man-fav".i18n(),
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildOngoingSessionItem() {
    return ListTile(
      onTap: () {},
      leading: const Icon(
        Icons.lock,
        color: Colors.white70,
      ),
      title: Text(
        "ongoing-session".i18n(),
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildSettingsItem() {
    return ListTile(
      onTap: () {},
      leading: const Icon(
        Icons.settings,
        color: Colors.white70,
      ),
      title: Text(
        "config".i18n(),
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      onTap: () => _showLogoutDialog(context),
      leading: const Icon(
        Icons.logout,
        color: Colors.white70,
      ),
      title: Text(
        "logout".i18n(),
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("logout".i18n()),
          content: Text("logout?".i18n()),
          actions: [
            TextButton(
              child: Text('no'.i18n()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('yes'.i18n()),
              onPressed: () {
                User().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
