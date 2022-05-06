// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';

class EquipmentAttachment {
  late int id;
  late String name, image;
  EquipmentAttachment.fromMap(map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "";
    image = map['image'] ?? "";
  }
}

class EquipmentAttachments {
  List<EquipmentAttachment> attachments = [];
  Future<EquipmentAttachments> fetchAttachments(int id) async {
    Response response =
        await API().get(endPoint: "equipment/$id/list-attachment/");
    if (response.statusCode == 200) {
      attachments = [];
      var data = response.data['data'];
      for (var map in data) {
        attachments.add(EquipmentAttachment.fromMap(map));
      }
    }
    return this;
  }

  Future<bool> update(
      BuildContext context, List<int> attachments, int id) async {
    context.loaderOverlay.show();
    Response response = await API().post(
        endPoint: "equipment/$id/link-attachment/", data: {"id": attachments});

    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!.clearSnackBars();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
