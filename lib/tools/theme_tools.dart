import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uta_library/tools/custom_size.dart';

class ThemeTools {
  static String darkMode = "dark";
  static String lightMode = "light";

  static Color primaryColor = CupertinoColors.activeOrange;
  static Color secondaryColor = Colors.blue;

  static double appBarTitleSize(BuildContext context) =>
      customSize(context).height * 0.03;

  // Check if the current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return ThemeProvider.controllerOf(context).currentThemeId ==
        ThemeTools.darkMode;
  }

  // if dark theme then light theme and vice versa
  static changeTheme(BuildContext context) =>
      ThemeProvider.controllerOf(context).nextTheme();

  // if the current theme is dark mode then return white color else black color
  static Color appBarForeGroundColor(BuildContext context) =>
      isDarkMode(context) ? Colors.white : Colors.black;

  // if the current theme is dark mode then return white color else black color
  static Color textButtonColor(BuildContext context) =>
      isDarkMode(context) ? Colors.white : Colors.black;

  // if the current theme is dark mode then return white color else black color
  static Color elevatedButtonBackGroundColor(BuildContext context) =>
      isDarkMode(context) ? Colors.white : Colors.black;

  // if the current theme is dark mode then return black color else white color
  static Color elevatedButtonForeGroundColor(BuildContext context) =>
      isDarkMode(context) ? Colors.black : Colors.white;

  // if the current theme is dark mode then return white color else black color
  static Color bottomNavigationBarForegroundColor(BuildContext context) =>
      isDarkMode(context) ? CupertinoColors.white : Colors.blue;
}
