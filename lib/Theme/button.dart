import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/colors.dart';

class TextButtonStyles {
  static ButtonStyle overlayButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: primaryColor,
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static ButtonStyle overlayOrderDetailButtonStyle({bool isRedColor = false}) {
    return TextButton.styleFrom(
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      elevation: 3,
      backgroundColor: isRedColor ? primaryColor : const Color(0xff47C678),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ).copyWith(
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );
  }
}
