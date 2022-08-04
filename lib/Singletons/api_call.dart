import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/main.dart';

class API {
  static final API _api = API._internal();

  factory API() => _api;

//Handles token expiration
  refreshToken({BuildContext? context, onCallback}) async {
    Response response;
    String path = "accounts/refresh/";
    try {
      response = await dio.get(
        path,
        options: Options(
          headers: {"refreshtoken": LoginSession().refreshToken},
        ),
      );

      if (response.statusCode == 200) {
        await LoginSession().setTokens(
          accessToken: response.data['access_token'],
          refreshToken: LoginSession().refreshToken,
          uuid: LoginSession().uuid,
          loginType: LoginSession().loginType,
        );
        await LoginSession().saveSession();
      }
    } on DioError {
      Get.offAll(() => LoginScreen());
    }
  }

  API._internal() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (req, handler) => handler.next(req),
      onResponse: (response, responseHandeler) {
        if (response.data == "") {
          scaffoldMessageKey.currentState!.clearSnackBars();
          scaffoldMessageKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                "Server Error",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 183, 50, 40),
              duration: Duration(milliseconds: 1100),
              dismissDirection: DismissDirection.horizontal,
            ),
          );
        }
        responseHandeler.next(response);
      },
      onError: (error, e) async {
        var res = error.response!;
        if (res.requestOptions.path == "accounts/refresh/") {
          Get.offAll(() => LoginScreen());
          return;
        } else if (res.statusCode == 403) {
          await refreshToken();
          e.next(error);
          return;
        } else if (res.statusCode == 500) {
          scaffoldMessageKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                "Service Error",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 183, 50, 40),
              duration: Duration(milliseconds: 1100),
              dismissDirection: DismissDirection.horizontal,
            ),
          );
          e.resolve(res);
          return;
        } else {
          e.resolve(res);
          return;
        }
      },
    ));
  }

  var dio = Dio(
    BaseOptions(
      baseUrl:
          // "",
          // "http://192.168.137.160:5000/",
          // 'http://192.168.1.71:4000/',
          // 'http://192.168.116.122:4000/',
          'https://api.rentallsolutions.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  Map<String, String> _getHeader(bool useToken) {
    if (useToken) {
      return {
        "Authorization": "Bearer " + LoginSession().accessToken!,
        "Content-Type": "application/json"
      };
    } else {
      return {"Content-Type": "application/json"};
    }
  }

  Future<Response> get({required String endPoint, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    log(LoginSession().accessToken.toString());
    response = await dio.get(
      endPoint,
      options: Options(headers: _getHeader(useToken)),
    );
    return response;
  }

  Future<Response> post(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    response = await dio.post(
      endPoint,
      data: data,
      options: Options(headers: _getHeader(useToken)),
    );
    return response;
  }

  Future<Response> delete(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    response = await dio.delete(
      endPoint,
      data: data,
      options: Options(headers: _getHeader(useToken)),
    );
    return response;
  }

  Future<Response> put(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    response = await dio.put(
      endPoint,
      data: data,
      options: Options(headers: _getHeader(useToken)),
    );
    return response;
  }

  Future<Response> patch(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    response = await dio.patch(
      endPoint,
      data: data,
      options: Options(headers: _getHeader(useToken)),
    );
    return response;
  }
}
