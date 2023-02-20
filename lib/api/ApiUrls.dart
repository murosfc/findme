class ApiUrls {
  static String _endpoint = "https://findnme.herokuapp.com/api/user";
  static String _register = "/register";
  static String _login = "/auth";
  static String _logout = "/logout";
  static String _getContacts = "/contacts";
  static String _getPendingContacts = "/contacts/pending";
  static String _addContact = "/contacts/add";
  static String _unBlockContact = "/contacts/un-block";
  static String _authorizeContact = "/contacts/authorize";
  static String _removeContact = "/contacts/remove";
  static String _userUpdate = "/update";
  static String _validatePassword = "/update/validate-pass";
  static String _updatePassword = "/update/password";
  static String _deleteUser = "/delete";

  static String registrationUrl() {
    return _endpoint + _register;
  }

  static String loginUrl() {
    return _endpoint + _login;
  }

  static String logoutUrl() {
    return _endpoint + _logout;
  }

  static String getContactsUrl() {
    return _endpoint + _getContacts;
  }

  static String pendingContactsUrl() {
    return _endpoint + _getPendingContacts;
  }

  static String addContactUrl() {
    return _endpoint + _addContact;
  }

  static String unBlockContactUrl() {
    return _endpoint + _unBlockContact;
  }

  static String authorizeContactUrl() {
    return _endpoint + _authorizeContact;
  }

  static String removeContactUrl() {
    return _endpoint + _removeContact;
  }

  static String updateUserUrl() {
    return _endpoint + _userUpdate;
  }

  static String validatePasswordUrl() {
    return _endpoint + _validatePassword;
  }

  static String updatedPasswordUrl() {
    return _endpoint + _updatePassword;
  }

  static String deleteUserUrl() {
    return _endpoint + _deleteUser;
  }
}
