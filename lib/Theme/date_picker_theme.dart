import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/colors.dart';

datePickerTheme(BuildContext context) => Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryColor, // header background color
        onPrimary: Colors.black, // header text color
        onSurface: primaryColor, // body text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.red,
          padding: const EdgeInsets.all(5),
          visualDensity: VisualDensity.compact,
          textStyle: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
    );
