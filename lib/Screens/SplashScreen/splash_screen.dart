// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/operator_dashboard_screen.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:wakelock/wakelock.dart';
import 'package:new_version/new_version.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key) {
    if (kDebugMode) Wakelock.enable();
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (await LoginSession().isSessionExist()) {
        if (LoginSession().isVender()) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => true,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OperatorDashboardScreen()),
            (route) => true,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkNewVersion();
  }

  checkNewVersion() async {
    NewVersion newVersion = NewVersion();
    try {
      final status = await newVersion.getVersionStatus();
      debugPrint(status!.canUpdate.toString());
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'New update available',
          dialogText:
              'You need updated app to get all the features of the system',
          updateButtonText: 'Update Now',
          dismissButtonText: 'Later',
          dismissAction: () {
            Navigator.pop(context);
          },
        );
      } else {
        navigate(context);
      }
    } catch (e) {
      navigate(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
}
