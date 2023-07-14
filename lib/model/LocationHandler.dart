import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/LocationDataApi.dart';
import 'Contact.dart';
import 'User.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class LocationHandler {
  Future<int> requestLocation(Contact contact) async {
    Map<String, dynamic> jsonData = {
      "token_requester": await User().getJwtToken(),
      "id_recipient": contact.id
    };
    String bodyJson = json.encode(jsonData);
    Response response = await http.post(
        Uri.parse(LocationDataApi.requestLocation),
        headers: {'Content-Type': 'application/json'},
        body: bodyJson);
    return response.statusCode;
  }

  Future<int> locationFeedBack(bool shared_location, String room_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final info_users = prefs.getString('info_users');

    if (info_users != null) {
      final response_data = json.decode(info_users);
      Map<String, dynamic> jsonData = {
        "info_users": response_data,
        "shared_location": shared_location,
        "room_id": room_id
      };

      String bodyJson = json.encode(jsonData);
      Response response = await http.post(
        Uri.parse(LocationDataApi.locationFeedBack),
        headers: {'Content-Type': 'application/json'},
        body: bodyJson,
      );
      return response.statusCode;
    }
    return 0; // Return a default value in case of failure or missing data
  }
}
