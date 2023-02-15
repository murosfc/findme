class ApiUrls {
  final String _endpoint = "http://192.168.1.166:8080";
  final _register = "/register";

  String getRegistrationUrl() {
    return _endpoint + _register;
  }
}
