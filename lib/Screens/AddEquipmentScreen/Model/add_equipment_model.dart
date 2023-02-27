// ignore_for_file: unused_field

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
}

class AddEquipmentModelModel {
  final String name;
  final String image;
  final bool isVATIncluded;
  final String location,
      dimension,
      weight,
      hor,
      menufacturedYear,
      counts,
      price,
      fuelIncludedRate,
      description,
      brand,
      capacity,
      application;

  final String imageId;

  AddEquipmentModelModel({
    required this.imageId,
    required this.name,
    required this.image,
    required this.location,
    required this.dimension,
    required this.weight,
    required this.hor,
    required this.isVATIncluded,
    required this.menufacturedYear,
    required this.counts,
    required this.price,
    required this.fuelIncludedRate,
    required this.description,
    required this.brand,
    required this.capacity,
    required this.application,
  });
}
