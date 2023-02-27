import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Utils/notification_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getLoginTypeToString(LoginType? loginType) {
  if (loginType == LoginType.vender) {
    return "vender";
  } else {
    return "operator";
  }
}

LoginType getStringToLoginType(String? loginType) {
  if (loginType == "vender") {
    return LoginType.vender;
  } else {
    return LoginType.operator;
  }
}

class LoginSession {
  static final LoginSession _loginSession = LoginSession._internal();
  factory LoginSession() => _loginSession;
  LoginSession._internal();

  String? accessToken, refreshToken, uuid;
  LoginType? loginType;

  setTokens({
    String? accessToken,
    String? refreshToken,
    String? uuid,
    LoginType? loginType,
  }) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.uuid = uuid;
    this.loginType = loginType;
  }

  saveSession() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken!);
    await prefs.setString('refresh_token', refreshToken!);
    await prefs.setString('uuid', uuid!);
    await prefs.setString('loginType', getLoginTypeToString(loginType!));
  }

  loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');
    uuid = prefs.getString('uuid');
    loginType = getStringToLoginType(prefs.getString('loginType'));
  }

  Future<bool> isSessionExist() async {
    await loadSession();
    if (uuid == null) {
      return false;
    }
    return true;
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    accessToken == null;
    refreshToken == null;
    uuid == null;
    loginType = null;
  }

  bool isVender() {
    return loginType == LoginType.vender;
  }

  getFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) async {
      await API().post(
        endPoint: "devices/",
        data: {
          "registration_id": token,
          "type": Platform.isIOS ? "ios" : "android"
        },
        useToken: true,
      );
      NotiService().listenToFCMNotification();
    });
  }
}
