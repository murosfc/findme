class ApiUrls {
  static String endpoint = "https://findnme.herokuapp.com/api/user";
  static String register = "/register";
  static String login = "/auth";
  static String logout = "/logout";
  static String getContacts = "/contacts";
  static String getPendingContacts = "/contacts/pending";
  static String addContact = "/contacts/add";
  static String unBlockContact = "/contacts/un-block";
  static String authorizeContact = "/contacts/authorize";
  static String removeContact = "/contacts/remove";
  static String userUpdate = "/update";
  static String validatePassword = "/update/validate-pass";
  static String updatePassword = "/update/password";
  static String deleteUser = "/delete";

  static String registrationUrl() {
    return endpoint + register;
  }

  static String loginUrl() {
    return endpoint + login;
  }

  static String logoutUrl() {
    return endpoint + logout;
  }

  static String getContactsUrl() {
    return endpoint + getContacts;
  }

  static String pendingContactsUrl() {
    return endpoint + getPendingContacts;
  }

  static String addContactUrl() {
    return endpoint + addContact;
  }

  static String unBlockContactUrl() {
    return endpoint + unBlockContact;
  }

  static String authorizeContactUrl() {
    return endpoint + authorizeContact;
  }

  static String removeContactUrl() {
    return endpoint + removeContact;
  }

  static String updateUserUrl() {
    return endpoint + userUpdate;
  }

  static String validatePasswordUrl() {
    return endpoint + validatePassword;
  }

  static String updatedPasswordUrl() {
    return endpoint + updatePassword;
  }

  static String deleteUserUrl() {
    return endpoint + deleteUser;
  }
}
