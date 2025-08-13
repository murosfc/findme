class AppConstants {
  static const String appName = 'FindMe';
  static const String appVersion = '1.0.0';
  
  static const Duration animationDuration = Duration(seconds: 10);
  static const Duration locationUpdateInterval = Duration(seconds: 5);
  
  static const double maxImageDistance = 10.0;
  static const double arrowThresholdRed = 20.0;
  static const double arrowThresholdYellow = 5.0;
  static const double cameraFacingThreshold = 10.0;
  
  static const int imageSize = 512;
  
  static const String userLogoNodeName = 'user-logo';
  static const String defaultImageUrl = 'https://raw.githubusercontent.com/murosfc/murosfc.github.io/main/user-logo.png';
  
  static const String pendingContactsType = "REQUESTS";
}

class AssetPaths {
  static const String images = 'assets/images/';
  static const String arrowRed = '${images}arrow-red.png';
  static const String arrowYellow = '${images}arrow-yellow.png';
  static const String arrowGreen = '${images}arrow-green.png';
  static const String defaultImage = '${images}default.png';
  static const String iconPath = 'assets/icon/icon.png';
}
