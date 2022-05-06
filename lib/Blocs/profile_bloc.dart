import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';

class ProfileAddress {
  late int id;
  late String country, district, state, tole, ward, address;
  ProfileAddress() {
    id = 0;
    country = "";
    district = "";
    state = "";
    tole = "";
    ward = "";
    address = "";
  }
  ProfileAddress.fromMap(map) {
    id = map['id'] ?? 0;
    country = map["country"] ?? "";
    district = map["district"] ?? "";
    state = map["state"] ?? "";
    tole = map["tole"] ?? "";
    ward = map["ward"] ?? "";
    address =
        tole + "-" + ward + ", " + district + ", " + state + ", " + country;
  }
  ProfileAddress.update({
    required this.id,
    required this.country,
    required this.district,
    required this.state,
    required this.tole,
    required this.ward,
    required this.address,
  });

  Future<bool> update(BuildContext context, id) async {
    context.loaderOverlay.show();
    Response response =
        await API().put(endPoint: "accounts/update-address/", data: {
      "country": country,
      "district": district,
      "id": id,
      "latitude": 0.0,
      "longitude": 0.0,
      "state": state,
      "tole": tole,
      "ward": ward,
    });
    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!.clearSnackBars();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
    context.read<ProfileCubit>().fetchProfile();
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

class ProfileContact {
  late int id;
  late String value, contactType;
  late bool isPrimary;
  ProfileContact.fromMap(map) {
    id = map['id'] ?? 0;
    value = map['value'] ?? "";
    contactType = map['contact_type'] ?? "";
    isPrimary = map['is_primary'] ?? false;
  }
}

class ProfileDocument {
  late String type, docId, image;
  late DateTime? expireDate;
  ProfileDocument.fromMap(map) {
    type = map['type'];
    image = map['image'];
    expireDate = DateTime.tryParse(map['expire_date']);
    docId = map["document_id"];
  }
}

class ProfileExperience {
  late int id;
  late String companyName, skill;
  late DateTime? startDate, endDate;
  ProfileExperience.fromMap(map) {
    id = map['id'];
    companyName = map['company'];
    skill = map['skill'];
    startDate = DateTime.tryParse(map['start_date']);
    endDate = DateTime.tryParse(map['end_date'] ?? "");
  }
}

class ProfileModel {
  int id = 0;
  String name = "", email = "", profile = "", description = "", pan = "";
  bool isContractDone = false, isKycVerified = false;
  List<ProfileContact> contacts = [];
  ProfileAddress address = ProfileAddress();
  List<ProfileDocument> documents = [];
  List<ProfileExperience> experiences = [];

  String perHourRate = "-", perDayRate = "-", perMonthRate = "-";
  fetchProfile() async {
    Response response = await API().get(endPoint: "accounts/profile/");
    if (response.statusCode == 200) {
      var data = response.data['data'];
      id = data['id'];
      email = data['email'] ?? "";
      name = data['name'] ?? "";
      profile = data['profile'] ?? "";
      description = data['description'] ?? "";
      pan = data['pan'] ?? "";
      isContractDone = data['is_contract_done'] ?? false;
      isKycVerified = data['is_kyc_verified'] ?? false;
      contacts = [];
      for (var element in data['contact']) {
        contacts.add(ProfileContact.fromMap(element));
      }
      if (data['address'].isNotEmpty) {
        address = ProfileAddress.fromMap(data['address'].first);
      }
      documents = [];
      for (var element in data['document']) {
        documents.add(ProfileDocument.fromMap(element));
      }
      experiences = [];
      if (data.containsKey("experience")) {
        for (var element in data['experience']) {
          experiences.add(ProfileExperience.fromMap(element));
        }
      }
      if (data.containsKey("rate")) {
        num rateNum = num.tryParse(data['rate'].toString()) ?? 0;
        if (rateNum != 0) {
          perHourRate = rateNum.toString() + "/Hr";
          perDayRate = (rateNum * 8).toString() + "/Day";
          perMonthRate = (rateNum * 8 * 26).toString() + "/Mon";
        }
      }
    }
  }

  copyData(ProfileModel model) {
    email = model.email;
    name = model.name;
    profile = profile;
  }
}

class ProfileCubit extends Cubit<ProfileModel> {
  ProfileCubit() : super(ProfileModel());

  Future<void> fetchProfile() async {
    ProfileModel newState = ProfileModel();
    await newState.fetchProfile();
    emit(newState);
  }
}
