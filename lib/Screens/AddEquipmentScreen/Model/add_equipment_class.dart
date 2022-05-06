// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Blocs/category_bloc.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/add_equipment_model_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AddEquipment {
  final String name, dimension, weight;
  final Category category;

  AddEquipment({
    required this.name,
    required this.dimension,
    required this.weight,
    required this.category,
  });

  submitEquipment(BuildContext context) async {
    context.loaderOverlay.show();
    Response response =
        await API().post(endPoint: "equipment/add-equipment/", data: {
      "category": category.id.toString(),
      "dimension": dimension,
      "name": name,
      "weight": weight,
    });

    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddEquipmentModelScreen(remoteId: response.data['data']['id']),
        ),
      );
    } else {
      final snackBar = SnackBar(
        content: Text(response.data['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
