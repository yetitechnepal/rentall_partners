import 'package:flutter/material.dart';

Color primaryColorCode = const Color(0xffF52E4C);

Map<int, Color> primaryColorMap = {
  50: primaryColorCode.withOpacity(.1),
  100: primaryColorCode.withOpacity(.2),
  200: primaryColorCode.withOpacity(.3),
  300: primaryColorCode.withOpacity(.4),
  400: primaryColorCode.withOpacity(.5),
  500: primaryColorCode.withOpacity(.6),
  600: primaryColorCode.withOpacity(.7),
  700: primaryColorCode.withOpacity(.8),
  800: primaryColorCode.withOpacity(.9),
  900: primaryColorCode.withOpacity(1),
};
MaterialColor primaryColor =
    MaterialColor(primaryColorCode.value, primaryColorMap);

Color darkColorBg = const Color(0xff1C1A1D);

Map<int, Color> darkColorBgMap = {
  50: darkColorBg.withOpacity(.1),
  100: darkColorBg.withOpacity(.2),
  200: darkColorBg.withOpacity(.3),
  300: darkColorBg.withOpacity(.4),
  400: darkColorBg.withOpacity(.5),
  500: darkColorBg.withOpacity(.6),
  600: darkColorBg.withOpacity(.7),
  700: darkColorBg.withOpacity(.8),
  800: darkColorBg.withOpacity(.9),
  900: darkColorBg.withOpacity(1),
};
MaterialColor darkColorBgColor =
    MaterialColor(darkColorBg.value, darkColorBgMap);

Color primaryColorDarkCode = const Color(0xFF91061B);

Map<int, Color> primaryColorDarkMap = {
  50: primaryColorDarkCode.withOpacity(.1),
  100: primaryColorDarkCode.withOpacity(.2),
  200: primaryColorDarkCode.withOpacity(.3),
  300: primaryColorDarkCode.withOpacity(.4),
  400: primaryColorDarkCode.withOpacity(.5),
  500: primaryColorDarkCode.withOpacity(.6),
  600: primaryColorDarkCode.withOpacity(.7),
  700: primaryColorDarkCode.withOpacity(.8),
  800: primaryColorDarkCode.withOpacity(.9),
  900: primaryColorDarkCode.withOpacity(1),
};
MaterialColor primaryColorDark =
    MaterialColor(primaryColorDarkCode.value, primaryColorDarkMap);
