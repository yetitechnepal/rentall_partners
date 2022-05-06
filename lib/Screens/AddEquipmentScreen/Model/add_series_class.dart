// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_model_class.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/add_equipment_photo.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AddSeries {
  List<Series> series = [];
  AddSeries(this.series);
  submit(BuildContext context, int id) async {
    context.loaderOverlay.show();
    List<Map<String, dynamic>> data = [];
    for (int index = 0; index < series.length; index++) {
      data.add({
        "count": series[index].count,
        "description": series[index].description,
        "equipment": series[index].equipment,
        "fuel_included_rate": series[index].fuelIncludedRate,
        "hour_of_renting": series[index].hourOfRenting,
        "location": series[index].location,
        "manufactured_year": series[index].menufatureDate,
        "model": series[index].model,
        "price": series[index].price,
        "series": series[index].seriesName,
      });
    }

    Response response = await API().post(
      endPoint: "equipment/add-series/",
      data: data,
    );

    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddEquipmentPhoto(equipId: id)));
    } else {
      final snackBar = SnackBar(content: Text(response.data['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
