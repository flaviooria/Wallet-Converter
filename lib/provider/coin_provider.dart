import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:pratica5/models/coin.dart';

class CoinProvider with ChangeNotifier {
  CoinProvider() {
    getCoinCountries();
    getCoinCryptos();
  }

  List<Coin> coinsCountries = [];
  List<Coin> coinsCryptos = [];
  List<Coin> coinsSearched = [];
  Coin? coinToConverted = null;
  double? valueCoinConversion = null;
  String typeCurrency = 'Countries';

  Future<void> getCoinCountries() async {
    final uri = Uri.parse(
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/coins_countries.json');

    var res = await get(uri);

    var data = coinsResponseFromJson(res.body).coins;
    //Ordenamos por orden alfabetico los paises
    data!.sort((a, b) => a.name![0].compareTo(b.name![0]));

    coinsCountries = data;
    notifyListeners();
  }

  Future<void> getCoinCryptos() async {
    final uri = Uri.parse(
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/coins_cryptos.json');

    var res = await get(uri);

    var data = coinsResponseFromJson(res.body).coins;
    //Ordenamos por orden alfabetico los paises
    data!.sort((a, b) => a.name![0].compareTo(b.name![0]));

    coinsCryptos = data;
    notifyListeners();
  }

  getCoinsCountriesByName(String query) {
    if (coinsCountries.isNotEmpty && query != '') {
      var coinsCopy = [...coinsCountries];
      coinsCopy = coinsCopy
          .where((element) =>
              element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      coinsSearched = coinsCopy;
    } else {
      coinsSearched = [];
    }

    notifyListeners();
  }

  getCoinsCryptoByName(String query) {
    if (coinsCryptos.isNotEmpty && query != '') {
      var coinsCopy = [...coinsCryptos];
      coinsCopy = coinsCopy
          .where((element) =>
              element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      coinsSearched = coinsCopy;
    } else {
      coinsSearched = [];
    }

    notifyListeners();
  }

  setCoinToConverted(Coin? coinConverted) {
    coinToConverted = coinConverted;
    notifyListeners();
  }

  setCoinValueConversion(double? value) {
    valueCoinConversion = value;
    notifyListeners();
  }

  setTypeCurrency(String currency) {
    typeCurrency = currency;
    print('cambia');
    notifyListeners();
  }
}
