import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class User {
  final _storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  User();

  Future<void> storeCredentials(Response response) async {
    final Map<String, dynamic> data = json.decode(response.body);
    await _storage.write(
        key: 'auth_token',
        value: data['token'],
        aOptions: _getAndroidOptions());
    await _storage.write(
        key: 'id', value: data['id'], aOptions: _getAndroidOptions());
    await _storage.write(
        key: 'name', value: data['name'], aOptions: _getAndroidOptions());
    await _storage.write(
        key: 'familyName',
        value: data['familyName'],
        aOptions: _getAndroidOptions());
    await _storage.write(
        key: 'pictureUrl',
        value: data['pictureUrl'],
        aOptions: _getAndroidOptions());
  }

  Future<void> flushUserData() async {
    try {
      await _storage.deleteAll(aOptions: _getAndroidOptions());
    } catch (e) {
      debugPrint('Error flushing user data: $e');
    }
  }

  Future<String?> getToken() async =>
      _storage.read(key: 'auth_token', aOptions: _getAndroidOptions());

  Future<String?> getId() async =>
      _storage.read(key: 'id', aOptions: _getAndroidOptions());

  Future<String?> getName() async =>
      _storage.read(key: 'name', aOptions: _getAndroidOptions());

  Future<String?> getFamilyName() async =>
      _storage.read(key: 'familyName', aOptions: _getAndroidOptions());

  Future<String?> getPictureUrl() async =>
      _storage.read(key: 'pictureUrl', aOptions: _getAndroidOptions());

  bool isUserLogged() => getPictureUrl() != null;
}
