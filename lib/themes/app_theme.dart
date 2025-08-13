import 'package:flutter/material.dart';
import '../colors/VisualIdColors.dart';

class AppTheme {
  static const Color _backgroundColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color _textPrimaryColor = Colors.white;
  static const Color _textSecondaryColor = Colors.white70;

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: VisualIdColors.colorGreen(),
      scaffoldBackgroundColor: _backgroundColor,
      brightness: Brightness.dark,
      textTheme: _buildTextTheme(),
      appBarTheme: _buildAppBarTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      cardTheme: CardThemeData(
        color: _backgroundColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      iconTheme: const IconThemeData(color: _textSecondaryColor),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        color: _textPrimaryColor,
        fontSize: 25.0,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: _textPrimaryColor,
        fontSize: 18.0,
      ),
      bodyMedium: TextStyle(
        color: _textSecondaryColor,
        fontSize: 16.0,
      ),
      bodySmall: TextStyle(
        color: _textSecondaryColor,
        fontSize: 14.0,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: VisualIdColors.colorGreen(),
      foregroundColor: _textPrimaryColor,
      elevation: 4.0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: _textPrimaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: VisualIdColors.colorGreen(),
        foregroundColor: _textPrimaryColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: VisualIdColors.colorGreen(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }


}
