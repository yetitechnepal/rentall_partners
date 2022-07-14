// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';

class AddEquipmentImages {
  List<String> images = [];

  AddEquipmentImages(this.images);

  submit(BuildContext context, {required int equipment}) async {
    context.loaderOverlay.show();
    var data = FormData.fromMap({"equipment": equipment});
    for (int index = 0; index < images.length; index++) {
      data.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(images[index],
              filename: "equipment" +
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  ".png"),
        ),
      );
    }
    Response response =
        await API().post(endPoint: "equipment/gallery/", data: data);

    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      final snackBar = SnackBar(
        content: Text(response.data['message']),
      );
      scaffoldMessageKey.currentState!.showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 1)),
        (route) => true,
      );
    } else {
      final snackBar = SnackBar(
        content: Text(response.data['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
