// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AddAttachmentModel {
  final String count,
      description,
      dimension,
      feulIncludedRate,
      baseRate,
      hourOfRenting,
      location,
      manufacturedYear,
      name,
      weight;

  AddAttachmentModel({
    required this.count,
    required this.description,
    required this.dimension,
    required this.feulIncludedRate,
    required this.baseRate,
    required this.hourOfRenting,
    required this.location,
    required this.manufacturedYear,
    required this.name,
    required this.weight,
  });
  Future<int> addAttachment(BuildContext context) async {
    context.loaderOverlay.show();
    Response response =
        await API().post(endPoint: "equipment/attachment/", data: {
      "count": count,
      "description": description,
      "dimension": dimension,
      "fuel_included_rate": feulIncludedRate,
      "hour_of_renting": baseRate,
      "location": location,
      "manufactured_year": manufacturedYear,
      "name": name,
      "price": baseRate,
      "weight": weight,
    });
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      return response.data['data']['id'];
    }
    return 0;
  }
}

class AddAttachmentImagesModel {
  List<String> imagesPaths = [];
  AddAttachmentImagesModel(this.imagesPaths);
  Future<bool> addAttachmentImages(int id) async {
    FormData formData = FormData.fromMap({"attachment": id});
    for (int index = 0; index < imagesPaths.length; index++) {
      formData.files.add(MapEntry(
        "image",
        await MultipartFile.fromFile(
          imagesPaths[index],
          filename: "attachment-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              '.jpg',
        ),
      ));
    }
    Response response =
        await API().post(endPoint: "equipment/gallery/", data: formData);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
