import 'package:findme/themes/app_theme.dart';
import 'package:findme/pages/ARScreen.dart';
import 'package:findme/pages/LoadingScreen.dart';
import 'package:findme/pages/Location/LocationConfirmation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.getInitialMessage();
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MaterialApp(
      localizationsDelegates: _buildLocalizationDelegates(),
      theme: _buildTheme(),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      home: const LoadingScreen(),
      routes: _buildRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }

  List<LocalizationsDelegate> _buildLocalizationDelegates() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      LocalJsonLocalization.delegate,
    ];
  }

  ThemeData _buildTheme() {
    return AppTheme.lightTheme;
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/location-confirmation': (context) => LocationConfirmationPage(),
      '/live_location_updates': (context) => ARScreen(),
      '/request-location': (context) => LocationConfirmationPage(),
    };
  }
}
