import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Calculation {
  static final Calculation _myClac = Calculation._internal();
  factory Calculation() {
    return _myClac;
  }
  Calculation._internal();

  static double degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  static Matrix4 _convertCoordinatesToMatrix(
      Map<String, double> remoteUserCoordinates) {
    Matrix4 remoteUserCoordinatesToMatrix = Matrix4.identity();
    double earthRadius = 6371000; // Approximate radius of the Earth in meters

    // Convert latitude and longitude to radians
    double latRad = degreesToRadians(remoteUserCoordinates['latitude']!);
    double lonRad = degreesToRadians(remoteUserCoordinates['longitude']!);

    // Calculate X, Y, Z coordinates on a sphere with Earth's radius
    double x = earthRadius * math.cos(latRad) * math.cos(lonRad);
    double y = earthRadius * math.sin(latRad);
    double z = earthRadius * math.cos(latRad) * math.sin(lonRad);

    // Set the translation values in the matrix
    remoteUserCoordinatesToMatrix.setEntry(0, 3, x);
    remoteUserCoordinatesToMatrix.setEntry(1, 3, y);
    remoteUserCoordinatesToMatrix.setEntry(2, 3, z);

    return remoteUserCoordinatesToMatrix;
  }

  double calculateDistanceBetweenUsers(
          Map<String, double> remoteUserCoordinates,
          Map<String, double> localUserCoordinates) =>
      Geolocator.distanceBetween(
          localUserCoordinates['latitude']!,
          localUserCoordinates['longitude']!,
          remoteUserCoordinates['latitude']!,
          remoteUserCoordinates['longitude']!);
}
