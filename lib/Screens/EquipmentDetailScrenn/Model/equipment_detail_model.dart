// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Singletons/login_session.dart';
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
    // withFuel = "";
    image = "";
    if (map['image'].length > 0) {
      image = map['image'].first.toString();
    }
  }
}

class EquipmentSeriesModel {
  late int id, counts;
  late String name,
      image,
      description,
      location,
      hor,
      dom,
      price,
      fuelIncludedRate;

  EquipmentSeriesModel.fromMap(map) {
    id = map['id'] ?? 0;
    name = map['series'] ?? "";
    image = map['image'] ?? "";
    description = map['description'] ?? "";
    location = map['location'] ?? "";
    hor = map['hor'] ?? "";
    dom = map['dom'] ?? "";
    counts = map['count'] ?? 0;
    price = map['price'] ?? "";
    fuelIncludedRate = map['fuel_included_rate'] ?? "";
  }
}

class EquipmentModelModel {
  late int id;
  late String name, image;
  List<EquipmentSeriesModel> series = [];
  EquipmentModelModel.fromJson(map) {
    id = map['id'] ?? 0;
    name = map['model'] ?? "";
    image = map['image'] ?? "";
    map['series']
        .forEach((map) => series.add(EquipmentSeriesModel.fromMap(map)));
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
        await API().get(endPoint: "equipment/company/$equipId/detail/");
    if (response.statusCode == 200) {
      models = [];
      attachments = [];
      try {
        var data = response.data['data']['equipment'];
        id = data['id'];
        name = data['name'];
        dimension = data['dimension'];
        weight = data['weight'];
        category = data['category'];
        isVerified = data['is_verified'] ?? false;
        for (var element in data['images']) {
          images.add(ImageModel.fromMap(element));
        }
        data['model']
            .forEach((map) => models.add(EquipmentModelModel.fromJson(map)));
        for (int index = 0;
            index < response.data['data']['attachment'].length;
            index++) {
          attachments.add(EquipmentAttractmentModel.fromMap(
              response.data['data']['attachment'][index]));
        }
      } catch (e) {}
    }
    context.read<EquipmentDetailModelCubit>().setEquipmentDetail(this);

    return this;
  }

  setUpdate({
    required int equipId,
    required int categoryId,
    required String name,
    required String dimension,
    required String weight,
  }) {
    catId = categoryId;
    id = equipId;
    this.name = name;
    this.dimension = dimension;
    this.weight = weight;
  }

  Future<bool> updateDetail(BuildContext context) async {
    context.loaderOverlay.show();
    Response response =
        await API().put(endPoint: "equipment/equipment/$id/", data: {
      "category": catId,
      "dimension": dimension,
      "name": name,
      "weight": weight,
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
