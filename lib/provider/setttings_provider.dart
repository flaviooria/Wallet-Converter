import 'package:flutter/material.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enum_settings.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    tStyleDefault = TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w600,
        color: AppSettings.colorPrimaryFont);

    getLoadData();
  }

  getLoadData() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences != null) {
      print('existe preferences');
      typeTheme = getThemeMode();
      numberDigits = getNumberDigits();
      getLoadStyleText();
      notifyListeners();
    }
  }

  ThemeMode getThemeMode() {
    String? theme = _preferences?.getString('theme');
    ThemeMode mode = ThemeMode.system;
    print('El tema guardado es: ${theme ?? 'no hay nada'}');

    if (theme != null) {
      if (theme == 'dark') {
        mode = ThemeMode.dark;
      } else if (theme == 'light') {
        mode = ThemeMode.light;
      } else {
        mode = ThemeMode.system;
      }
    }
    return mode;
  }

  int getNumberDigits() {
    int? numDigits = _preferences?.getInt('digits');
    if (numDigits != null) {
      if (numDigits == 2) {
        typeDigits = NumberDigits.two;
        return 2;
      } else {
        typeDigits = NumberDigits.three;
        return 3;
      }
    }
    typeDigits = NumberDigits.cero;
    return 0;
  }

  getLoadStyleText() {
    font = _preferences?.getString('font');

    if (font != null) {
      if (font == 'normal') {
        font = 'Gilroy';
        fontWeight = FontWeight.normal;
        typeText = StyleText.system;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
      } else {
        font = 'Gilroy-ExtraBold';
        fontWeight = FontWeight.bold;
        typeText = StyleText.black;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
      }
    } else {
      font = 'Gilroy';
      fontWeight = FontWeight.normal;
      typeText = StyleText.system;
    }
  }

  //Shared Preferences
  SharedPreferences? _preferences;

  //Settings
  ThemeMode? typeTheme;
  NumberDigits? typeDigits;
  StyleText? typeText;
  Brightness? brightness;
  int? numberDigits;

  //Settings Enum Theme App
  List<ThemeMode> themeOptions = ThemeMode.values;
  List<StyleText> styleTextOptions = StyleText.values;
  List<NumberDigits> numberDigitsOptions = NumberDigits.values;

  //Colors App
  String? font;
  FontWeight? fontWeight;
  TextStyle? tStyleDefault;
  Color? backgroundSearch;

  setTheme(ThemeMode value) async {
    await _preferences!.remove('theme');
    switch (value) {
      case ThemeMode.system:
        typeTheme = value;
        await _preferences!.setString('theme', 'system');
        break;
      case ThemeMode.dark:
        typeTheme = value;
        brightness = Brightness.dark;
        backgroundSearch = Color.fromARGB(255, 85, 84, 84).withOpacity(0.5);
        await _preferences!.setString('theme', 'dark');
        break;
      case ThemeMode.light:
        typeTheme = value;
        brightness = Brightness.light;
        backgroundSearch = Colors.grey[200];
        await _preferences!.setString('theme', 'light');
        break;
    }
    notifyListeners();
  }

  setNumberDigits(NumberDigits value) async {
    await _preferences!.remove('digits');
    switch (value) {
      case NumberDigits.cero:
        typeDigits = value;
        numberDigits = 0;
        await _preferences!.setInt('digits', numberDigits!);
        break;
      case NumberDigits.two:
        typeDigits = value;
        numberDigits = 2;
        await _preferences!.setInt('digits', numberDigits!);
        break;
      case NumberDigits.three:
        typeDigits = value;
        numberDigits = 3;
        await _preferences!.setInt('digits', numberDigits!);
        break;
    }
    notifyListeners();
  }

  setTextStyle(StyleText value) async {
    await _preferences!.remove('font');

    switch (value) {
      case StyleText.system:
        typeText = value;
        font = 'Gilroy';
        fontWeight = FontWeight.normal;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
        await _preferences!.setString('font', 'normal');
        break;
      case StyleText.black:
        typeText = value;
        font = 'Gilroy-ExtraBold';
        fontWeight = FontWeight.bold;
        tStyleDefault = TextStyle(
            fontFamily: font,
            fontWeight: fontWeight,
            color: AppSettings.colorPrimaryFont);
        await _preferences!.setString('font', 'bold');
        break;
    }
    notifyListeners();
  }
}
