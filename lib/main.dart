import 'package:findme/colors/VisualIdColors.dart';
import 'package:findme/pages/ARScreen.dart';
import 'package:findme/pages/FindnMeHome.dart';
import 'package:findme/pages/LoadingScreen.dart';
import 'package:findme/pages/Location/LocationConfirmation.dart';
import 'package:findme/pages/Location/LiveLocationUpdates.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await FirebaseMessaging.instance.getInitialMessage();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  runApp(const MyApp(isNotification: false));
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
  var context;
  runApp(const MyApp(isNotification: true));
}

class MyApp extends StatelessWidget {
  final bool? isNotification;

  const MyApp({Key? key, required this.isNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    if (isNotification == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationConfirmationPage()),
        );
      });
    }
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      theme: ThemeData(
        primarySwatch: VisualIdColors.colorGreen(),
        scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      home: const LoadingScreen(),
      routes: {
        '/location-confirmation': (context) => LocationConfirmationPage(),
        '/live_location_updates': (context) => ARScreen(),
        '/request-location': (context) => LocationConfirmationPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
