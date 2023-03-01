import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final storage = const FlutterSecureStorage();

  User();

  Future<void> storeCredentials(Response response) async {
    final Map<String, dynamic> data = json.decode(response.body);
    await storage.write(key: 'auth_token', value: data['token']);
    await storage.write(key: 'id', value: data['id']);
    await storage.write(key: 'name', value: data['name']);
    await storage.write(key: 'familyName', value: data['familyName']);
  }

  Future<void> flushUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await storage.deleteAll();
    } catch (e) {
      print('Error flushing user data: $e');
    }
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('name') ?? '';
    return username;
  }

  Future<String> getToken() async {
    String authToken = storage.read(key: 'auth_token').toString();
    print("\n\nToken:");
    print(authToken);
    return authToken;
  }
}
