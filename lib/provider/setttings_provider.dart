import 'package:flutter/material.dart';
import 'package:pratica5/utils/AppSettings.dart';

import '../models/enum_settings.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    tStyleDefault = TextStyle(
        fontFamily: 'Gilroy-ExtraBold',
        fontWeight: FontWeight.w600,
        color: AppSettings.colorPrimaryFont);
  }

  //Settings
  ThemeMode? typeTheme = ThemeMode.system;
  NumberDigits? typeDigits = NumberDigits.cero;
  StyleText? typeText = StyleText.system;

  List<ThemeMode> themeOptions = ThemeMode.values;
  List<StyleText> styleTextOptions = StyleText.values;
  List<NumberDigits> numberDigitsOptions = NumberDigits.values;
  Brightness? brightness = Brightness.light;
  int? numberDigits = 0;

  //Colors App
  String font = 'Gilroy';
  FontWeight fontWeight = FontWeight.normal;

  TextStyle? tStyleDefault;

  Color? backgroundSearch;

  setTheme(ThemeMode value) {
    switch (value) {
      case ThemeMode.system:
        typeTheme = value;
        break;
      case ThemeMode.dark:
        typeTheme = value;
        brightness = Brightness.dark;
        backgroundSearch = Color.fromARGB(255, 85, 84, 84).withOpacity(0.5);
        break;
      case ThemeMode.light:
        typeTheme = value;
        brightness = Brightness.light;
        backgroundSearch = Colors.grey[200];

        break;
    }
    notifyListeners();
  }

  setNumberDigits(NumberDigits value) {
    switch (value) {
      case NumberDigits.cero:
        typeDigits = value;
        numberDigits = 0;
        break;
      case NumberDigits.two:
        typeDigits = value;
        numberDigits = 2;
        break;
      case NumberDigits.three:
        typeDigits = value;
        numberDigits = 3;
        break;
    }
    notifyListeners();
  }

  setTextStyle(StyleText value) {
    switch (value) {
      case StyleText.system:
        typeText = value;
        font = 'Gilroy';
        fontWeight = FontWeight.normal;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
        break;
      case StyleText.black:
        typeText = value;
        font = 'Gilroy-ExtraBold';
        fontWeight = FontWeight.bold;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
        break;
    }
    notifyListeners();
  }
}
