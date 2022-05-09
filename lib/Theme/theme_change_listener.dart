import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

listernToTheme(BuildContext context) {
  AdaptiveTheme.of(context).modeChangeNotifier.addListener(() async {
    ThemeData theme = AdaptiveTheme.of(context).theme;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: theme.brightness,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
      ),
    );
  });
}
