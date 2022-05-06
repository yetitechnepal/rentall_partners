import 'package:flutter/material.dart';

enum OrderTypes {
  pending,
  confirmed,
  dispatch,
  completed,
  cancelled,
  batchclosed
}

Color getOrderTypeColorCode(BuildContext context, OrderTypes type) {
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  if (type == OrderTypes.pending) {
    return Color(isDarkTheme ? 0xFFE0C10F : 0xffFFDA0F);
  } else {
    return Color(isDarkTheme ? 0xFF61AC5A : 0xFF74CB6D);
  }
}

String getOrderTypeString(OrderTypes type) {
  if (type == OrderTypes.pending) {
    return "Pending";
  } else if (type == OrderTypes.confirmed) {
    return "Confirmed";
  } else if (type == OrderTypes.dispatch) {
    return "Dispatch";
  } else if (type == OrderTypes.completed) {
    return "Completed";
  } else if (type == OrderTypes.batchclosed) {
    return "Batch Closed";
  } else {
    return "Cancelled";
  }
}
