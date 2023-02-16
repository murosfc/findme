class ApiUrls {
  static String _endpoint = "http://192.168.1.166:8080/api/user";
  static String _register = "/register";
  static String _login = "/auth";

  static String registrationUrl() {
    return _endpoint + _register;
  }

  static String loginUrl() {
    return _endpoint + _login;
  }
}
