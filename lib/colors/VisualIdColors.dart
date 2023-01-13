import 'package:flutter/material.dart';

class VisualIdColors {
  static MaterialColor colorGreen() {
    Map<int, Color> color = {
      50: Color.fromRGBO(0, 176, 159, .1),
      100: Color.fromRGBO(0, 176, 159, .2),
      200: Color.fromRGBO(0, 176, 159, .3),
      300: Color.fromRGBO(0, 176, 159, .4),
      400: Color.fromRGBO(0, 176, 159, .5),
      500: Color.fromRGBO(0, 176, 159, .6),
      600: Color.fromRGBO(0, 176, 159, .7),
      700: Color.fromRGBO(0, 176, 159, .8),
      800: Color.fromRGBO(0, 176, 159, .9),
      900: Color.fromRGBO(0, 176, 159, 1),
    };
    return MaterialColor(0xFF00b09f, color);
  }

  static MaterialColor colorBlue() {
    Map<int, Color> color = {
      50: Color.fromRGBO(0, 113, 176, .1),
      100: Color.fromRGBO(0, 113, 176, .2),
      200: Color.fromRGBO(0, 113, 176, .3),
      300: Color.fromRGBO(0, 113, 176, .4),
      400: Color.fromRGBO(0, 113, 176, .5),
      500: Color.fromRGBO(00, 113, 176, .6),
      600: Color.fromRGBO(0, 113, 176, .7),
      700: Color.fromRGBO(0, 113, 176, .8),
      800: Color.fromRGBO(0, 113, 176, .9),
      900: Color.fromRGBO(0, 113, 176, 1),
    };
    return MaterialColor(0xFF0071b0, color);
  }
}
