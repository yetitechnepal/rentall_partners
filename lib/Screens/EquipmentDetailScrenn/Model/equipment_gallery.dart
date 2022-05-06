// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EquipmentGallery {
  List<AssetEntity> imageEntities = [];
  EquipmentGallery(this.imageEntities);

  Future<bool> submit(BuildContext context, {required int id}) async {
    context.loaderOverlay.show();
    var data = FormData.fromMap({"equipment": id});
    for (int index = 0; index < imageEntities.length; index++) {
      data.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            (await imageEntities[index].file)!.path,
            filename: "equipment" +
                DateTime.now().millisecondsSinceEpoch.toString() +
                ".jpg",
          ),
        ),
      );
    }
    Response response =
        await API().post(endPoint: "equipment/gallery/", data: data);

    context.loaderOverlay.show();
    final snackBar = SnackBar(content: Text(response.data['message']));
    scaffoldMessageKey.currentState!.showSnackBar(snackBar);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static deleteImage(BuildContext context, int imageId) async {
    Response response = await API()
        .delete(endPoint: "equipment/gallery/", data: {"image_id": imageId});

    if (response.statusCode == 200) {
      final snackBar = SnackBar(content: Text(response.data['message']));
      scaffoldMessageKey.currentState!.showSnackBar(snackBar);
      return true;
    } else {
      final snackBar = SnackBar(content: Text(response.data['message']));
      scaffoldMessageKey.currentState!.showSnackBar(snackBar);
      return false;
    }
  }
}
