import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

loader(BuildContext context) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: BoxShadows.dropShadow(context),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Lottie.asset(
              "assets/animation/loading.json",
              width: 200,
            ),
          ),
        ),
      ),
    ),
  );
}
