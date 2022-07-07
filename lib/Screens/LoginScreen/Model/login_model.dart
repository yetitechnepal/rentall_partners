// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/main.dart';

class LoginModel {
  late String email, password;
  LoginModel(this.email, this.password);
  Future<bool> doLogin(BuildContext context,
      {required LoginType loginType}) async {
    context.loaderOverlay.show();
    Response response;
    if (loginType == LoginType.vender) {
      response = await API().post(
        endPoint: "accounts/client-login/",
        data: {"email": email, "password": password},
        useToken: false,
      );
    } else {
      response = await API().post(
        endPoint: "operator/login/",
        data: {"email": email, "password": password},
        useToken: false,
      );
    }
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      var data = response.data['data'];
      LoginSession().setTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        uuid: data['uuid'],
        loginType: loginType,
      );
      LoginSession().saveSession();
      scaffoldMessageKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Welcome! You are logged in'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1200),
        ),
      );
      return true;
    } else {
      scaffoldMessageKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Cannot login check your credentials'),
          duration: Duration(seconds: 1),
        ),
      );
      return false;
    }
  }
}
