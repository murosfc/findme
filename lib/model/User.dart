import 'dart:convert';
import 'package:findme/api/ApiUrls.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class User {
  final _storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  User();

  Future<void> storeCredentials(Response response) async {
    final Map<String, dynamic> data = json.decode(response.body);
    await _storage.write(
        key: 'token', value: data['token'], aOptions: _getAndroidOptions());
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

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<String?> readSecureData(String key) async {
    var readData =
        await _storage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<bool> isUserLogged() async {
    var readData =
        await _storage.read(key: "token", aOptions: _getAndroidOptions());
    if (readData == null) {
      return false;
    }
    Response response = await http
        .get(Uri.parse(ApiUrls.checkToken), headers: {'token': readData});
    if (response.statusCode != 401) {
      return true;
    }
    return false;
  }
}
