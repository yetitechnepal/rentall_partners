// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/add_euipment_series_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class Series {
  final String count,
      description,
      fuelIncludedRate,
      hourOfRenting,
      location,
      menufatureDate,
      price,
      seriesName,
      modelName;
  final int equipment, model;

  Series({
    required this.count,
    required this.description,
    required this.fuelIncludedRate,
    required this.hourOfRenting,
    required this.location,
    required this.menufatureDate,
    required this.price,
    required this.seriesName,
    required this.equipment,
    required this.model,
    required this.modelName,
  });
}

class Model {
  final int id;
  final String name;

  Model(this.id, this.name);
}

class EquipModel {
  final String name, image;
  EquipModel({required this.name, required this.image});
}

class EquipModels {
  List<EquipModel> models = [];
  submit(BuildContext context, int id) async {
    List<Model> modelList = [];
    context.loaderOverlay.show();
    for (int index = 0; index < models.length; index++) {
      var formData = FormData.fromMap({
        'model': models[index].name,
        'image': await MultipartFile.fromFile(models[index].image,
            filename: 'model' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '.png')
      });
      Response response = await API()
          .post(endPoint: "equipment/$id/add-models/", data: formData);

      if (response.statusCode == 200) {
        modelList.add(
          Model(
            response.data['data'][0]['id'],
            response.data['data'][0]['model_name'],
          ),
        );
      } else {
        final snackBar = SnackBar(content: Text(response.data['message']));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    context.loaderOverlay.hide();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEquipmentSeriesScreen(
          modelList: modelList,
          equipId: id,
        ),
      ),
    );
  }
}
