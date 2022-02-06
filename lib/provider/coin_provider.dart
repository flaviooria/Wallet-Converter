import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:pratica5/models/coin_countrie.dart';

class CoinCountrieProvider with ChangeNotifier {
  CoinCountrieProvider() {
    getCountries();
  }

  List<CoinCountrie> coins = [];
  List<CoinCountrie> coinsSearched = [];
  CoinCountrie? coinToConverted = null;
  double? valueCoinConversion = null;

  Future<void> getCountries() async {
    final uri = Uri.parse(
        'https://wallet-46c79-default-rtdb.europe-west1.firebasedatabase.app/coins_countries.json');

    var res = await get(uri);

    var data = coinCountrieResponseFromJson(res.body).coins;
    //Ordenamos por orden alfabetico los paises
    data!.sort((a, b) => a.name![0].compareTo(b.name![0]));

    coins = data;
    notifyListeners();
  }

  getCoinsCountriesByName(String query) {
    if (coins.isNotEmpty && query != '') {
      var coinsCopy = [...coins];
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

  setCoinToConverted(CoinCountrie coinConverted) {
    coinToConverted = coinConverted;
    notifyListeners();
  }

  setCoinValueConversion(double value) {
    valueCoinConversion = value;
    notifyListeners();
  }
}
