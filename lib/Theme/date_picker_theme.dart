import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/colors.dart';

datePickerTheme(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.black,
        onSurface: primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.all(5),
          visualDensity: VisualDensity.compact,
          textStyle: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
    );
  } else {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white70,
        onSurface: Colors.white70,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.all(5),
          visualDensity: VisualDensity.compact,
          textStyle: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
