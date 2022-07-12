// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Blocs/category_bloc.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_model.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/add_equipment_photo.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AddEquipment {
  final String name, dimension, weight, description;
  final Category category;
  List<String> images = [];
  List<AddEquipmentModelModel> models = [];
  AddEquipment({
    required this.name,
    required this.dimension,
    required this.weight,
    required this.category,
    required this.description,
  });

  submitEquipment(BuildContext context) async {
    context.loaderOverlay.show();

    List<Map<String, dynamic>> mapModels = [];
    List<MultipartFile> images = [];
    for (var model in models) {
      images.add(
        await MultipartFile.fromFile(
          model.image,
          filename: "${DateTime.now().microsecondsSinceEpoch}.jpg",
        ),
      );
      mapModels.add({
        "name": model.name,
        "description": model.description,
        "location": model.location,
        "dimension": model.dimension,
        "weight": model.weight,
        "hour_of_renting": model.hor,
        "manufactured_year": model.menufacturedYear,
        "count": model.counts,
        "price": model.price,
        "fuel_included_rate": model.fuelIncludedRate,
      });
    }

    Map<String, dynamic> data = {
      "name": name,
      "category": category.id.toString(),
      "model": json.encode(mapModels),
      "image": images,
    };
    log(data.toString());
    // return;

    FormData formData = FormData.fromMap(data);

    Response response =
        await API().post(endPoint: "equipment/add-equipment/", data: formData);

    context.loaderOverlay.hide();
    log(response.data.toString());
    if (response.statusCode == 200) {
      int id = response.data['data'];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddEquipmentPhoto(equipId: id)),
      );
    } else {
      final snackBar = SnackBar(
        content: Text(response.data['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
