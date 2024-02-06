import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late BuildContext context;

  void configureFirebaseMessaging(BuildContext appContext) {
    context = appContext;

    if (FirebaseMessaging.instance != null) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("FCM Message: $message");
        _showNotification(message);
      });

      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    } else {
      print("FirebaseMessaging instance is null");
    }
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("FCM Message (background): $message");
    // Handle background messages
    _showNotification(message);
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      print('Received notification: ${notification.title} - ${notification.body}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification.body ?? ''),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              // Handle dismiss action if needed
            },
          ),
        ),
      );
    }
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  Future<String?> getFCMToken() async {
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    return token;
  }
}
