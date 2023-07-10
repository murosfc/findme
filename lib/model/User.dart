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
  // ignore_for_file: constant_identifier_names

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
    print("approveRequest");
    String? token = await _readSecureData("token");
    if (token == null) {
      logout();
    } else {
      String bodyJson = json.encode({'id': contact.id});
      Response response = await http.post(Uri.parse(UserDataApi.authorizeContact),
          body: bodyJson,
          headers: {'token': token, "content-type": "application/json"});
      print(response.statusCode);   
      if (response.statusCode == ResponseStatusCode.SUCCESS) {
        return true;
      } else if (response.statusCode == ResponseStatusCode.BAD_CREDENTIALS) {
        logout();         
      }        
    }
    return false;
  }

  Future<String?> _readSecureData(String key) async {
    var readData =
        await _storage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<Contact?> addContact(String email) async {
    String? token = await _readSecureData("token");
    if (token == null) {
      logout();
    } else {
      String bodyJson = json.encode({'email': email});
      Response response = await http.post(Uri.parse(UserDataApi.addContact),
          body: bodyJson,
          headers: {'token': token, "content-type": "application/json"});
      if (response.statusCode == ResponseStatusCode.SUCCESS) {
        String jsonString = response.body;
        dynamic newContactJson = json.decode(jsonString);
        Contact newContact = Contact(
            newContactJson['id'],
            newContactJson['name'],
            newContactJson['familyName'],
            newContactJson['pictureUrl']);
        return newContact;
      } else if (response.statusCode == ResponseStatusCode.BAD_CREDENTIALS) {
        logout();
        throw Exception('invalid-token'.i18n());
      } else if (response.statusCode == ResponseStatusCode.FORBIDDEN) {
        throw Exception('already-contact'.i18n());
      } else if (response.statusCode == ResponseStatusCode.NOT_FOUND) {
        throw Exception('contact-not-found'.i18n());
      } else {
        throw Exception('server-error'.i18n());
      }
    }
    return null;
  }

  Future<List<Contact>> getContactList(String type) async {
    String url = '';
    const PENDING_TYPE = "REQUESTS";
    List<Contact> contacts = [];
    String? token = await _readSecureData("token");
    if (token == null) {
      logout();
    }
    type == PENDING_TYPE
        ? url = UserDataApi.getPendingContacts
        : url = "${UserDataApi.getContacts}$type";
    Response response =
        await http.get(Uri.parse(url), headers: {'token': token!});
    if (response.statusCode == ResponseStatusCode.SUCCESS) {
      String jsonString = response.body;
      List<dynamic> jsonList = json.decode(jsonString);
      for (var jsonObj in jsonList) {
        int id = jsonObj['id'];
        String name = jsonObj['name'];
        String familyName = jsonObj['familyName'];
        String pictureUrl = jsonObj['pictureUrl'];
        contacts.add(Contact(id, name, familyName, pictureUrl));
      }
    }
    return contacts;
  }

  void logout() {
    deleteAllSecureData();
  }

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<bool> isUserLogged() async {
    String? token = await _readSecureData("token");
    if (token == null) {
      return false;
    }
    Response response = await http
        .get(Uri.parse(UserDataApi.checkToken), headers: {'token': token});
    return response.statusCode != ResponseStatusCode.BAD_CREDENTIALS;
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

  String getFullName() {
    return "${_readSecureData("name")} ${_readSecureData("familyName")}";
  }

  Future<String?> getFamilyName() async {
    return _readSecureData("familyName");
  }

  Future<String?> getPictureUrl() async {
    return _readSecureData("pictureUrl");
  }

  
}
