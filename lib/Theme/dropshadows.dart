import 'package:flutter/material.dart';

class BoxShadows {
  static List<BoxShadow> dropShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          offset: const Offset(0, 0),
          spreadRadius: 0,
          blurRadius: 3,
        ),
      ];
  static List<BoxShadow> selectedDropShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
          offset: const Offset(0, 0),
          spreadRadius: 0,
          blurRadius: 3,
        ),
      ];
}
