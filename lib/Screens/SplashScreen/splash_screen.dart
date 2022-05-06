// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/operator_dashboard_screen.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:wakelock/wakelock.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key) {
    if (kDebugMode) Wakelock.enable();
    setupInteractedMessage();
  }

  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (await LoginSession().isSessionExist()) {
        if (LoginSession().isVender()) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OperatorDashboardScreen()),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    navigate(context);
    return Scaffold(
      backgroundColor: const Color(0xffED1A25),
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          height: 150,
        ),
      ),
    );
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true,
    //   sound: true,
    // );
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // void _handleMessage(RemoteMessage message) {}
}
