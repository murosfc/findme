class ApiUrls {
  // static const String endpoint = "https://findnme.herokuapp.com/api/user";
  static const String endpoint = "http://localhost:8080/api/user";
  static const String endpointLocation = "http://127.0.0.1:5000/";

  static const String registration = "$endpoint/register";
  static const String login = "$endpoint/auth";
  static const String logout = "$endpoint/logout";
  static const String getContacts =
      "$endpoint/contacts?type="; //add parameter type=
  static const String getPendingContacts = "$endpoint/contacts/pending";
  static const String addContact = "$endpoint/contacts/add";
  static const String unBlockContact = "$endpoint/contacts/un-block";
  static const String authorizeContact = "$endpoint/contacts/authorize";
  static const String removeContact = "$endpoint/contacts/remove";
  static const String userUpdate = "$endpoint/update";
  static const String validatePassword = "$endpoint/update/validate-pass";
  static const String updatePassword = "$endpoint/update/password";
  static const String deleteUser = "$endpoint/delete";
  static const String checkToken = "$endpoint/check/token";

  /*static String registrationUrl() => endpoint + register;

  static String loginUrl() => endpoint + login;

  static String getContactsUrl() => endpoint + getContacts;

  static String pendingContactsUrl() => endpoint + getPendingContacts;

  static String addContactUrl() => endpoint + addContact;

  static String unBlockContactUrl() => endpoint + unBlockContact;

  static String authorizeContactUrl() => endpoint + authorizeContact;

  static String removeContactUrl() => endpoint + removeContact;

  static String updateUserUrl() => endpoint + userUpdate;

  static String validatePasswordUrl() => endpoint + validatePassword;

  static String updatedPasswordUrl() => endpoint + updatePassword;

  static String deleteUserUrl() => endpoint + deleteUser;

  static String checkTokenValid() => endpoint + checkToken;*/
}
