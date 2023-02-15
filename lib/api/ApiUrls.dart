class ApiUrls {
  final String _endpoint = "http://192.168.1.166:8080/api/user";
  final String _register = "/register";
  final String _login = "/auth";

  String registrationUrl() {
    return _endpoint + _register;
  }

  String logintionUrl() {
    return _endpoint + _login;
  }
}
