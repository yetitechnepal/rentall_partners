import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/colors.dart';

ThemeData lightThemeData = ThemeData(
  androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  primarySwatch: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  shadowColor: Colors.black.withOpacity(0.14),
  disabledColor: const Color(0xffE4E4E4),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    shadowColor: Colors.black26,
    elevation: 2,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Color(0xff717171)),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: primaryColor),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColor),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      elevation: MaterialStateProperty.all(3),
      shadowColor: MaterialStateProperty.all(Colors.black54),
      overlayColor: MaterialStateProperty.all(primaryColor.withRed(200)),
      padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(primaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

ThemeData darkThemeData = ThemeData(
  androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  primarySwatch: primaryColorDark,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkColorBgColor,
  primaryColor: primaryColorDark,
  disabledColor: const Color(0xFF262626),
  shadowColor: Colors.white.withOpacity(0.14),
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorBg,
    foregroundColor: Colors.white,
    shadowColor: Colors.white24,
    elevation: 2,
    centerTitle: true,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white.withOpacity(0.8)),
    bodyText2: TextStyle(color: Colors.white.withOpacity(0.6)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColorDark),
      foregroundColor: MaterialStateProperty.all(Colors.white70),
      elevation: MaterialStateProperty.all(3),
      shadowColor: MaterialStateProperty.all(Colors.white24),
      overlayColor: MaterialStateProperty.all(primaryColorDark.withRed(200)),
      padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(primaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);
