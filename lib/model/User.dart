import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  User();

  static Future<void> storeCredentials(Response response) async {
    final Map<String, dynamic> data = json.decode(response.body);
    const storage = FlutterSecureStorage();
    await storage.write(key: 'auth_token', value: data['token']);
    await storage.write(key: 'id', value: data['id']);
    await storage.write(key: 'name', value: data['name']);
    await storage.write(key: 'familyName', value: data['familyName']);
  }

  static Future<void> flushUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('name') ?? '';
    return username;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('auth_token') ?? '';
    return username;
  }
}
