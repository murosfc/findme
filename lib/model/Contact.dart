import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:localization/localization.dart';

import '../api/ApiUrls.dart';
import 'User.dart';

class Contact {
  final int id;
  final String name;
  final String familyName;
  final String pictureURL;

  Contact(this.id, this.name, this.familyName, this.pictureURL);

  String getFirstNamesLetters() {
    return name[0] + familyName[0];
  }

  static Future<Contact> addContact(String email) async {
    User user = User();
    String? token = await user.readSecureData("token");
    String bodyJson = json.encode({'email': email});
    Response response = await http.post(Uri.parse(ApiUrls.addContact),
        body: bodyJson,
        headers: {'token': token!, "content-type": "application/json"});
    if (response.statusCode == 200 && response.body != null) {
      String jsonString = response.body;
      dynamic newContactJson = json.decode(jsonString);
      Contact newContact = Contact(newContactJson['id'], newContactJson['name'],
          newContactJson['familyName'], newContactJson['pictureUrl']);
      return newContact;
    } else if (response.statusCode == 401) {
      user.deleteAllSecureData();
      throw Exception('invalid-token'.i18n());
    } else if (response.statusCode == 403) {
      throw Exception('already-contact'.i18n());
    } else if (response.statusCode == 404) {
      throw Exception('contact-not-found'.i18n());
    } else {
      throw Exception('server-error'.i18n());
    }
  }

  static Future<List<Contact>> getContactList(String type) async {
    String url = '';
    User user = User();
    List<Contact> contacts = [];
    String? token = await user.readSecureData("token");
    if (type == "REQUESTS") {
      url = ApiUrls.getPendingContacts;
    } else {
      url = "${ApiUrls.getContacts}$type";
    }
    Response response =
        await http.get(Uri.parse(url), headers: {'token': token!});
    if (response.statusCode == 200 && response.body != null) {
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
}
