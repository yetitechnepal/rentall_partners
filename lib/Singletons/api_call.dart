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

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    Response response;
    if (requestOptions.method == "get") {
      response = await get(endPoint: requestOptions.path);
    } else if (requestOptions.method == "post") {
      response =
          await post(endPoint: requestOptions.path, data: requestOptions.data);
    } else if (requestOptions.method == "put") {
      response =
          await put(endPoint: requestOptions.path, data: requestOptions.data);
    } else if (requestOptions.method == "delete") {
      response = await delete(
          endPoint: requestOptions.path, data: requestOptions.data);
    } else {
      response =
          await patch(endPoint: requestOptions.path, data: requestOptions.data);
    }
    return response;
  }

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
        DioError dioError = error;
        if (res.requestOptions.path == "accounts/refresh/") {
          Get.offAll(() => LoginScreen());
          return;
        } else if (res.statusCode == 403) {
          await refreshToken();
          var ress = await _retry(res.requestOptions);
          dioError.response = ress;
          e.next(dioError);
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
          e.next(dioError);
          return;
        } else {
          e.next(dioError);
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
          'https://partners.rentallsolutions.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  Future<Response> get({required String endPoint, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    log(LoginSession().accessToken.toString());
    if (useToken) {
      response = await dio.get(
        endPoint,
        options: Options(
          headers: {"Authorization": "Bearer " + LoginSession().accessToken!},
        ),
      );
    } else {
      response = await dio.get(endPoint);
    }
    log(response.data.toString());
    return response;
  }

  Future<Response> post(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    try {
      if (useToken) {
        response = await dio.post(
          endPoint,
          data: data,
          options: Options(
            headers: {"Authorization": "Bearer " + LoginSession().accessToken!},
          ),
        );
      } else {
        response = await dio.post(
          endPoint,
          data: data,
        );
      }
    } on DioError catch (e) {
      response = e.response!;
    }

    log(response.data.toString());
    return response;
  }

  Future<Response> delete(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    try {
      if (useToken) {
        response = await dio.delete(
          endPoint,
          data: data,
          options: Options(
            headers: {"Authorization": "Bearer " + LoginSession().accessToken!},
          ),
        );
      } else {
        response = await dio.delete(
          endPoint,
          data: data,
        );
      }
    } on DioError catch (e) {
      response = e.response!;
    }

    log(response.data.toString());
    return response;
  }

  Future<Response> put(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    try {
      if (useToken) {
        response = await dio.put(
          endPoint,
          data: data,
          options: Options(
            headers: {"Authorization": "Bearer " + LoginSession().accessToken!},
          ),
        );
      } else {
        response = await dio.put(
          endPoint,
          data: data,
        );
      }
    } on DioError catch (e) {
      response = e.response!;
    }

    log(response.data.toString());
    return response;
  }

  Future<Response> patch(
      {required String endPoint, dynamic data, bool useToken = true}) async {
    Response response;
    log(dio.options.baseUrl + endPoint);
    try {
      if (useToken) {
        response = await dio.patch(
          endPoint,
          data: data,
          options: Options(
            headers: {"Authorization": "Bearer " + LoginSession().accessToken!},
          ),
        );
      } else {
        response = await dio.patch(
          endPoint,
          data: data,
        );
      }
    } on DioError catch (e) {
      response = e.response!;
    }
    log(response.data.toString());
    return response;
  }
}
