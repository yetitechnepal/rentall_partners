import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';

Widget addButton(BuildContext context, {Function()? onPressed}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: BoxShadows.dropShadow(context),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        AEMPLIcon(
          AEMPLIcons.add,
          color: primaryColor,
        ),
        TextButton(
          style: TextButtonStyles.overlayButtonStyle(),
          onPressed: onPressed,
          child: Container(),
        ),
      ],
    ),
  );
}
