import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications {
  // Solicita permissão para receber notificações do Firebase Messaging
  static void requestFirebaseMessagingPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicita permissão para receber notificações
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Manipula o status da permissão
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        print('Usuário concedeu permissão');
        // Agora é possível utilizar o Firebase Cloud Messaging
        break;
      case AuthorizationStatus.denied:
        print('Usuário negou permissão');
        // Tratar caso o usuário tenha negado permissão
        break;
      case AuthorizationStatus.notDetermined:
        print('Permissão não determinada');
        // Tratar caso a permissão não tenha sido determinada
        break;
      case AuthorizationStatus.provisional:
        print('Permissão concedida provisionalmente');
        // Tratar caso a permissão tenha sido concedida provisionalmente (iOS 14+)
        break;
    }
  }

  //https://www.youtube.com/watch?v=AUU6gbDni4Q
  //https://www.youtube.com/watch?v=hJA09GwURtk
  // Inicializa as informações para Android e iOS. No vídeo, ele fala sobre iOS, mas foi implementado apenas para Android.
  static void initInfo(BuildContext context) async {
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidInitialize);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize the plugin and handle notification tap
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    );
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final data = message.data;
        final screen = data['screen'];
        final info_users = data['info_users'];
        final room_id = data['room_id'];

        final prefs = await SharedPreferences.getInstance();

        if (room_id == 'none') {
          // Salva as informações do solicitante para uso posterior, se necessário
          await prefs.setString('info_users', json.encode(info_users));
        } else if ('room_id' != 'none') {
          await prefs.setString('room_id', room_id);
          final infoUsersJson = json.decode(info_users);

          await prefs.setString(
              'name_user', infoUsersJson['recipient']['name']);
        }

        if (screen != null && screen != 'none') {
          if (screen == 'request_location') {
            Navigator.pushReplacementNamed(context, '/location-confirmation');
          } else if (screen == 'live_location_updates') {
            Navigator.pushReplacementNamed(context, '/live_location_updates');
          }
        }

        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification?.body ?? '',
          htmlFormatBigText: true,
          contentTitle: message.notification?.title.toString(),
          htmlFormatContent: true,
        );

        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'locationChannel',
          'requestLocation',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.max,
          playSound: false,
        );

        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['title'],
        );
      });
    } catch (e) {
      print(e);
    }

    // Implementação específica da plataforma para lidar com mensagens em segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Implementar código específico da plataforma para mensagens em segundo plano
    // Verificar a plataforma e exibir uma notificação local em vez de navegar
    final data = message.data;

    final String name = data['name'];
    final String surname = data['familyName'];
    final screen = data['screen'];
  }

  static Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {}
}
