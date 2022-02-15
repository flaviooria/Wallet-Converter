import 'dart:convert';

import 'package:http/http.dart';
import 'package:pratica5/models/settings.dart';

class SettingsApi {
  static Future<bool> addNewDevice(String deviceID) async {
    final url =
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/devices/$deviceID.json';

    final device = {
      'isFirstView': true,
      'theme': 'system',
      'numberDigits': 2,
      'textStyle': 'normal'
    };

    var res = await put(Uri.parse(url), body: jsonEncode(device));

    return res.statusCode == 200;
  }

  static Future<Settings?> getDeviceById(String deviceID) async {
    final url =
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/devices/${deviceID}.json';

    var res = await get(Uri.parse(url));

    if (res.body == 'null') {
      return null;
    } else {
      return Settings.fromJson(jsonDecode(res.body));
    }
  }

  static Future<bool> updateSetting(
      Map<String, dynamic> value, String deviceID) async {
    final url =
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/devices/$deviceID.json';

    var res = await put(Uri.parse(url), body: jsonEncode(value));

    return res.statusCode == 200;
  }
}
