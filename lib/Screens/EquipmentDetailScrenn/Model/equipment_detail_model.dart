// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';

class EquipmentAttractmentModel {
  late int id;
  late String name, description, dimension, price, withFuel, image;
  EquipmentAttractmentModel.fromMap(map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "";
    description = map['description'] ?? "";
    price = map['price'] ?? "";
    dimension = map['dimension'] ?? "";
    withFuel = map['fuel_included_rate'] ?? "";
    image = "";
    if (map['image'].length > 0) {
      image = map['image'].first.toString();
    }
  }
}

class EquipmentModelModel {
  late int id;
  late String name,
      image,
      description,
      location,
      hor,
      dom,
      price,
      fuelIncludedRate,
      dimension,
      weight;
  late int counts;
  EquipmentModelModel.fromJson(map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "";
    image = map['image'] ?? "";
    dimension = map['dimension'] ?? "";
    weight = map['weight'] ?? "";

    description = map['description'] ?? "";
    location = map['location'] ?? "";
    hor = map['hor'] ?? "";
    dom = map['dom'] ?? "";
    price = map['price'] ?? "";
    fuelIncludedRate = map['fuel_included_rate'] ?? "";
    counts = map['count'] ?? 0;
  }
}

class ImageModel {
  late int id;
  late String imagePath;
  ImageModel.fromMap(map) {
    id = map['id'];
    imagePath = map['path'];
  }
}

class EquipmentDetailModel {
  int id = 0;
  String name = "", dimension = "", weight = "", category = "";
  int catId = 0;
  bool isVerified = false;
  List<ImageModel> images = [];
  List<EquipmentModelModel> models = [];

  List<EquipmentAttractmentModel> attachments = [];

  Future<EquipmentDetailModel> fetchEquipmentDetail(
      BuildContext context, int equipId) async {
    Response response =
        await API().get(endPoint: "vendor/equipment/$equipId/detail/");
    if (response.statusCode == 200) {
      models = [];
      attachments = [];
      try {
        var data = response.data['data']['equipment'];
        id = data['id'];
        name = data['name'];
        category = data['category'];
        isVerified = data['is_verified'] ?? false;
        for (var image in data['images']) {
          images.add(ImageModel.fromMap(image));
        }
        for (var model in data['model']) {
          models.add(EquipmentModelModel.fromJson(model));
        }
        for (int index = 0;
            index < response.data['data']['attachment'].length;
            index++) {
          attachments.add(EquipmentAttractmentModel.fromMap(
              response.data['data']['attachment'][index]));
        }
      } catch (e) {
        log(e.toString());
      }
    }
    context.read<EquipmentDetailModelCubit>().setEquipmentDetail(this);

    return this;
  }

  setUpdate({
    required int equipId,
    required int categoryId,
    required String name,
  }) {
    catId = categoryId;
    id = equipId;
    this.name = name;
  }

  Future<bool> updateDetail(BuildContext context) async {
    context.loaderOverlay.show();

    Response response =
        await API().put(endPoint: "equipment/$id/update/", data: {
      "category": catId,
      "name": name,
    });

    context.loaderOverlay.hide();
    final snackBar = SnackBar(content: Text(response.data['message']));
    scaffoldMessageKey.currentState!.showSnackBar(snackBar);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class EquipmentDetailModelCubit extends Cubit<EquipmentDetailModel> {
  EquipmentDetailModelCubit() : super(EquipmentDetailModel());
  setEquipmentDetail(EquipmentDetailModel detail) {
    emit(detail);
  }
}
