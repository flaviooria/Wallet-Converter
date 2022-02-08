// To parse this JSON data, do
//
//     final coinCountrie = coinCountrieFromMap(jsonString);

import 'dart:convert';

class Coin {
  Coin({
    this.id,
    this.codeFlag,
    this.name,
    this.rate,
    this.symbol,
  });

  String? id;
  String? codeFlag;
  String? name;
  double? rate;
  String? symbol;

  factory Coin.fromJson(Map<String, dynamic> json, String id_fb) => Coin(
        id: id_fb,
        codeFlag: json["code_flag"],
        name: json["name"],
        rate: json["rate"].toDouble() ?? 0.0,
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "code_flag": codeFlag,
        "name": name,
        "rate": rate,
        "symbol": symbol,
      };
}

class CoinCountrieResponse {
  List<Coin>? coins;

  CoinCountrieResponse.fromJson(parsedJson) {
    coins = getCoins(parsedJson);
  }

  List<Coin> getCoins(Map<String, dynamic> parsedJson) {
    List<String>? id_values = parsedJson.keys.toList();
    return id_values
        .map((id_coin) => Coin.fromJson(parsedJson[id_coin], id_coin))
        .toList();
  }
}

CoinCountrieResponse coinsResponseFromJson(String json) =>
    CoinCountrieResponse.fromJson(jsonDecode(json));
