import 'dart:math';

class AppUtils {
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters > 1000) {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(2)} Km';
    } else {
      return '${distanceInMeters.toStringAsFixed(2)} m';
    }
  }

  static double calculateArrowAngle(double heading, double bearing) {
    double arrowAngle = heading - bearing;

    if (arrowAngle < 0) {
      arrowAngle = arrowAngle.abs() / 180 * 90;
    } else {
      arrowAngle = -arrowAngle / 180 * 90;
    }
    
    return arrowAngle;
  }

  static String getArrowImagePath(double arrowAngle) {
    const String basePath = 'assets/images/';
    
    if (arrowAngle.abs() > 20) {
      return '${basePath}arrow-red.png';
    } else if (arrowAngle.abs() > 5) {
      return '${basePath}arrow-yellow.png';
    } else {
      return '${basePath}arrow-green.png';
    }
  }

  static double constrainDistance(double distance, double maxDistance) {
    return distance > maxDistance ? maxDistance : distance;
  }

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static bool isWithinThreshold(double value, double threshold) {
    return value.abs() <= threshold;
  }
}
