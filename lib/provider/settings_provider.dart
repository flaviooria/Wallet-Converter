import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:pratica5/models/settings.dart';
import 'package:pratica5/services/settings_api.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enum_settings.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    tStyleDefault = TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w600,
        color: AppSettings.colorPrimaryFont);

    load();
    /**
     * Aqui lo que hacia antes era cargar directamente cada future
     */
    // getLoadData();
    // initPlatformState();
  }

  //Shared Preferences
  SharedPreferences? _preferences;

  //Settings
  ThemeMode? typeTheme;
  NumberDigits? typeDigits;
  StyleText? typeText;
  Brightness? brightness;
  int? numberDigits;
  bool? isFirstViewIntro;
  String? _deviceID;
  Settings? newSettings;

  //Settings Enum Theme App
  List<ThemeMode> themeOptions = ThemeMode.values;
  List<StyleText> styleTextOptions = StyleText.values;
  List<NumberDigits> numberDigitsOptions = NumberDigits.values;

  //Colors App
  String? font;
  FontWeight? fontWeight;
  TextStyle? tStyleDefault;
  Color? backgroundSearch;

  load() async {
    await initPlatformState();
  }

  Future<void> getLoadData() async {
    if (_preferences != null) {
      print('1. existe preferences');
      typeTheme = getThemeModePreferences();
      numberDigits = getNumberDigitsPreferences();
      isFirstViewIntro = _preferences?.getBool('intro') ?? true;
      print(isFirstViewIntro);
      getLoadStyleTextPreferences();
      notifyListeners();
    } else {
      valueDefaults();
    }
  }

  Future<void> initPlatformState() async {
    valueDefaults();
    print('0. deviceID');
    //Cargamos tanto como las preferencias y el id device para obtener la id del dispositivo
    _deviceID = await PlatformDeviceId.getDeviceId;
    _preferences = await SharedPreferences.getInstance();

    if (_deviceID != null) {
      Settings? setting = await SettingsApi.getDeviceById(_deviceID!);

      if (setting == null) {
        //Si es null pues lo que haremos es añadirlo a nuestra bd de firebase
        var res = await SettingsApi.addNewDevice(_deviceID!);

        if (res) {
          newSettings = await SettingsApi.getDeviceById(_deviceID!);
          newSettings!.isFirstView = false;
          var ok = await SettingsApi.updateSetting(
              newSettings!.toJson(), _deviceID!);

          print(ok ? 'intro a false' : 'no intro');
        }
      } else {
        //Aqui hago todo para setear datos de estilos
        newSettings = setting;
        isFirstViewIntro = setting.isFirstView;
        setThemeFirebase(setting);
        setNumberDigitsFirebase(setting);
        setStylesFirebase(setting);
      }
    } else {
      //Aqui cargo los del shared preferences si no me cargara el internet para la petición a los servicios
      await getLoadData();
    }

    print(_deviceID ?? 'no carga');
    notifyListeners();
  }

  void setStylesFirebase(Settings setting) {
    if (setting.textStyle != null) {
      if (setting.textStyle == 'normal') {
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

  void setNumberDigitsFirebase(Settings setting) {
    if (setting.numberDigits != null) {
      if (setting.numberDigits == 2) {
        typeDigits = NumberDigits.two;
        numberDigits = 2;
      } else {
        typeDigits = NumberDigits.three;
        numberDigits = 3;
      }
    }
    typeDigits = NumberDigits.cero;
    numberDigits = 0;
  }

  void setThemeFirebase(Settings setting) {
    ThemeMode mode = ThemeMode.system;
    if (setting.theme != null) {
      if (setting.theme == 'dark') {
        mode = ThemeMode.dark;
      } else if (setting.theme == 'light') {
        mode = ThemeMode.light;
      } else {
        mode = ThemeMode.system;
      }
      typeTheme = mode;
    }
  }

  ThemeMode getThemeModePreferences() {
    String? theme = _preferences?.getString('theme');
    ThemeMode mode = ThemeMode.system;
    print('2. El tema guardado es: ${theme ?? 'no hay nada'}');

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

  int getNumberDigitsPreferences() {
    print('3. digitos');
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

  getLoadStyleTextPreferences() {
    print('4. styles');
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
      valueDefaults();
    }
  }

  void valueDefaults() {
    font = 'Gilroy';
    fontWeight = FontWeight.normal;
    typeText = StyleText.system;
    typeDigits = NumberDigits.two;
    numberDigits = 2;
    typeTheme = ThemeMode.system;
    isFirstViewIntro = true;
  }

  setFirstViewIntro(bool value) async {
    isFirstViewIntro = value;
    await _preferences!.remove('intro');
    await _preferences!.setBool('intro', value);
    notifyListeners();
  }

  /**
   * Metodos del provider para setear valores
   */
  setTheme(ThemeMode value) async {
    String mode = 'system';

    await _preferences!.remove('theme');
    switch (value) {
      case ThemeMode.system:
        typeTheme = value;
        await _preferences!.setString('theme', 'system');
        mode = 'system';
        //setFirstViewIntro(true);
        break;
      case ThemeMode.dark:
        typeTheme = value;
        brightness = Brightness.dark;
        backgroundSearch = Color.fromARGB(255, 85, 84, 84).withOpacity(0.5);
        await _preferences!.setString('theme', 'dark');
        mode = 'dark';
        break;
      case ThemeMode.light:
        typeTheme = value;
        brightness = Brightness.light;
        backgroundSearch = Colors.grey[200];
        await _preferences!.setString('theme', 'light');
        mode = 'light';
        break;
    }

    newSettings!.theme = mode;
    await SettingsApi.updateSetting(newSettings!.toJson(), _deviceID!);
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
    newSettings!.numberDigits = numberDigits;
    await SettingsApi.updateSetting(newSettings!.toJson(), _deviceID!);
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
        newSettings!.textStyle = 'normal';
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
        newSettings!.textStyle = 'bold';
        break;
    }
    await SettingsApi.updateSetting(newSettings!.toJson(), _deviceID!);
    notifyListeners();
  }
}
