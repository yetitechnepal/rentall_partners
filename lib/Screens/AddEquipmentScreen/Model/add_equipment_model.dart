// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:rental_partners/Blocs/category_bloc.dart';

class AddEquipmentModel {
  String _name = "", _dimension = "", _weight = "", _description = "";
  late Category _category;

  late List<AddEquipmentModelModel> models = [];

  List<String> imagePaths = [];
  setEquipment({
    required String name,
    required String dimension,
    required String weight,
    required String description,
    required Category category,
  }) {
    _name = name;
    _dimension = dimension;
    _weight = weight;
    _description = description;
    _category = category;
  }

  setModels(List<AddEquipmentModelModel> modelsList) => models = modelsList;

  setImagePaths(List<String> images) {
    imagePaths = images;
  }

  void submitEqupment(BuildContext context) {}
}

class AddEquipmentModelModel {
  final String name;
  final String image;
  final String imageId;

  List<AddEquipmentSeriesModel> series = [];

  AddEquipmentModelModel({
    required this.name,
    required this.image,
    required this.imageId,
  });
}

class AddEquipmentSeriesModel {
  final String name,
      hourOfRenting,
      equipmentCurrentLocation,
      frequency,
      baseRate,
      feulInclusionRate,
      description;
  final DateTime manufactureDate;

  AddEquipmentSeriesModel({
    required this.name,
    required this.hourOfRenting,
    required this.equipmentCurrentLocation,
    required this.frequency,
    required this.baseRate,
    required this.feulInclusionRate,
    required this.description,
    required this.manufactureDate,
  });
}
