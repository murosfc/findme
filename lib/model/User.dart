import 'dart:async';
import 'dart:convert';
import 'package:findme/api/ResponseStatusCode.dart';
import 'package:findme/api/UserDataApi.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:localization/localization.dart';
import 'Contact.dart';
import 'Notifications.dart';

class User {
  static final User _myUser = User._internal();
  final _storage = const FlutterSecureStorage(); 

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  factory User() {
    return _myUser;
  }

  User._internal();

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
    await _storage.write(
        key: 'fcmToken',
        value: data['fcmToken'],
        aOptions: _getAndroidOptions());
  }

  Future<int> login(String email, String password) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    String bodyJson = json
        .encode({'email': email, 'password': password, 'fcmToken': fcmToken});
    Response response = await http.post(Uri.parse(UserDataApi.login),
        headers: {'Content-Type': 'application/json'}, body: bodyJson);
    if (response.statusCode == ResponseStatusCode.SUCCESS) {      
      storeCredentials(response);              
    }
    return response.statusCode;
  }

  Future<int> register(Map<String, String> body) async {
    String bodyJson = json.encode(body);
    Response response = await http.post(Uri.parse(UserDataApi.registration),
        headers: {'Content-Type': 'application/json'}, body: bodyJson);
    return response.statusCode;
  }

  Future<bool> approveRequest(Contact contact) async { 
    final token = await _readSecureData("token");
    if (token == null) {
      logout();
      return false;
    }

    final bodyJson = json.encode({'id': contact.id});
    final response = await http.post(
      Uri.parse(UserDataApi.authorizeContact),
      body: bodyJson,
      headers: {'token': token, "content-type": "application/json"},
    );
    
    if (response.statusCode == ResponseStatusCode.SUCCESS) {
      return true;
    } else if (response.statusCode == ResponseStatusCode.BAD_CREDENTIALS) {
      logout();
    }
    
    return false;
  }

  Future<String?> _readSecureData(String key) async {
    var readData =
        await _storage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<Contact?> addContact(String email) async {
    final token = await _readSecureData("token");
    if (token == null) {
      logout();
      return null;
    }

    final bodyJson = json.encode({'email': email});
    final response = await http.post(
      Uri.parse(UserDataApi.addContact),
      body: bodyJson,
      headers: {'token': token, "content-type": "application/json"},
    );

    switch (response.statusCode) {
      case ResponseStatusCode.SUCCESS:
        final newContactJson = json.decode(response.body);
        return Contact(
          newContactJson['id'],
          newContactJson['name'],
          newContactJson['familyName'],
          newContactJson['pictureUrl'],
        );
      case ResponseStatusCode.BAD_CREDENTIALS:
        logout();
        throw Exception('invalid-token'.i18n());
      case ResponseStatusCode.FORBIDDEN:
        throw Exception('already-contact'.i18n());
      case ResponseStatusCode.NOT_FOUND:
        throw Exception('contact-not-found'.i18n());
      default:
        throw Exception('server-error'.i18n());
    }
  }

  Future<List<Contact>> getContactList(String type) async {
    const pendingType = "REQUESTS";
    final token = await _readSecureData("token");
    
    if (token == null) {
      logout();
      return [];
    }

    final url = type == pendingType
        ? UserDataApi.getPendingContacts
        : "${UserDataApi.getContacts}$type";

    final response = await http.get(
      Uri.parse(url),
      headers: {'token': token},
    );

    if (response.statusCode == ResponseStatusCode.SUCCESS) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((jsonObj) => Contact(
                jsonObj['id'] as int,
                jsonObj['name'] as String,
                jsonObj['familyName'] as String,
                jsonObj['pictureUrl'] as String,
              ))
          .toList();
    }
    
    return [];
  }

  void logout() {
    deleteAllSecureData();
  }

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<bool> isUserLogged() async {
    try {
      final token = await _readSecureData("token");
      if (token == null) return false;
      
      final response = await http.get(
        Uri.parse(UserDataApi.checkToken),
        headers: {'token': token},
      );
      
      return response.statusCode != ResponseStatusCode.BAD_CREDENTIALS;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getJwtToken() async {
    return _readSecureData("token");
  }

  Future<String?> getFcmToken() async {
    return _readSecureData("fcmToken");
  }

  Future<String?> getName() async {
    return _readSecureData("name");
  }

  Future<String?> getFullName() async {
    final name = await _readSecureData("name");
    final familyName = await _readSecureData("familyName");
    return "$name $familyName";
  }

  Future<String?> getFamilyName() async {
    return _readSecureData("familyName");
  }

  Future<String?> getPictureUrl() async {
    return _readSecureData("pictureUrl");
  }

  
}
