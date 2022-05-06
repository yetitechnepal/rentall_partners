import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class NotificationModel {
  late int id;
  late String type, title, message;
  String? image, colorCode;
  int? orderId, invoiceNumber;
  DateTime? dateTime;
  Color color = Color(0x0ff00000);

  NotificationModel.fromMap(map) {
    id = map['id'] ?? 0;
    type = map['notification_type'] ?? "";
    title = map['title'] ?? "";
    message = map['message'] ?? "";
    image = map['cover_photo'] ?? "";
    dateTime = DateTime.tryParse(map['entered_date']);
    orderId = map['order'];
    colorCode = map['color_code'];
    invoiceNumber = map['invoice_number'];
  }
}

class NotificationsModel {
  List<NotificationModel> notifications = [];
  Future<NotificationsModel> fetchNotificaions() async {
    Response response = await API().get(endPoint: "notification/all/");
    if (response.statusCode == 200) {
      notifications = [];
      var data = response.data['data'];
      for (var element in data) {
        notifications.add(NotificationModel.fromMap(element));
      }
    }
    return this;
  }
}
