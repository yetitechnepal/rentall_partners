import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/main.dart';

class Experience {
  final int skillType;
  final String companyName, skillName;
  final bool isCurrentlyWorking;
  final DateTime startDate;
  final DateTime? endDate;

  Experience({
    required this.skillType,
    required this.skillName,
    required this.companyName,
    required this.isCurrentlyWorking,
    required this.startDate,
    this.endDate,
  });
}

class VenderModel {
  String companyName = "", pan = "", information = "";
  String? imagePath;
  String state = "", district = "", ward = "", tole = "", country = "";
  String primaryEmail = "", primaryPhone = "", secondaryPhone = "";
  String password = "", otp = "";
  List<Experience> experiences = [];
  LoginType loginType = LoginType.vender;

  bool setLoginType(LoginType login) {
    log(login.toString());
    log(loginType.toString());
    if (loginType == login) {
      return true;
    } else {
      loginType = login;
      return false;
    }
  }

  setGeneratInformation({
    required String companyName,
    required String imagePath,
    required String pan,
    required String information,
  }) {
    this.companyName = companyName;
    this.imagePath = imagePath;
    this.pan = pan;
    this.information = information;
  }

  setAddressInformation({
    required String state,
    required String district,
    required String ward,
    required String tole,
    required String country,
  }) {
    this.district = district;
    this.state = state;
    this.ward = ward;
    this.tole = tole;
    this.country = country;
  }

  setContactinformation({
    required String primaryEmail,
    required String primaryPhone,
    required String secondaryPhone,
  }) {
    this.primaryEmail = primaryEmail;
    this.primaryPhone = primaryPhone;
    this.secondaryPhone = secondaryPhone;
  }

  verifyOTP(BuildContext context, String otp) {}

  requestOTP() async {
    Response response = await API().post(
      endPoint: "v2/accounts/otp/",
      data: {"email": primaryEmail},
      useToken: false,
    );
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
  }

  setPassword({required String password, required String otp}) {
    this.password = password;
    this.otp = otp;
  }

  Future<bool> register(BuildContext context) async {
    context.loaderOverlay.show();
    var data = {
      "general_info": {
        "name": companyName,
        "email": primaryEmail,
        "description": information,
        "password": password,
        "otp": otp
      },
      "contact": {
        "secondary_email": primaryEmail,
        "primary_phone": primaryPhone,
        "secondary_phone": secondaryPhone
      },
      "address": {
        "ward": ward,
        "tole": tole,
        "state": state,
        "district": district,
        "country": country
      },
      "experience": [],
    };
    Response response = await API().post(
        endPoint: "accounts/partner-registration/",
        data: data,
        useToken: false);

    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
    log(response.data.toString());
    if (response.statusCode == 200) {
      var data = response.data['data'];
      String access = data['access_token'];
      String refresh = data['refresh_token'];
      String uuid = data['uuid'];
      LoginSession().setTokens(
        accessToken: access,
        refreshToken: refresh,
        uuid: uuid,
        loginType: LoginType.vender,
      );
      LoginSession().saveSession();
      return true;
    } else {
      return false;
    }
  }
}

class VenderModelCubit extends Cubit<VenderModel> {
  VenderModelCubit() : super(VenderModel());

  resetData() {
    VenderModel vender = VenderModel();
    vender.setLoginType(state.loginType);
    emit(vender);
  }
}
