import 'dart:async';

import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService firebaseService = FirebaseService();
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;

    // Configure Firebase Messaging with context
    notificationServices.configureFirebaseMessaging(context);
    if (user != null) {
      Timer(
        Duration(seconds: 1),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionScreen()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo1.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Blog!',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
