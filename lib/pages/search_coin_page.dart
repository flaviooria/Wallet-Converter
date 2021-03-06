import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:pratica5/models/coin.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:pratica5/widget/select_currency.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class SearchCoinPage extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    final settingProvider = Provider.of<SettingsProvider>(context);

    List<Coin>? coins;
    if (coinProvider.typeCurrency.toLowerCase() == 'countries') {
      coins = coinProvider.coinsSearched.isEmpty
          ? coinProvider.coinsCountries
          : coinProvider.coinsSearched;
    } else {
      coins = coinProvider.coinsSearched.isEmpty
          ? coinProvider.coinsCryptos
          : coinProvider.coinsSearched;
    }

    final size = MediaQuery.of(context).size;

    //Aqui uso el metodo del textController que es un escuchador de eventos!!!
    textController.addListener(() {
      final query = textController.text;
      coinProvider.typeCurrency.toLowerCase() == 'countries'
          ? coinProvider.getCoinsCountriesByName(query)
          : coinProvider.getCoinsCryptoByName(query);
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                _searchBar(size, settingProvider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Select type currency',
                        style: TextStyle(
                            fontFamily: settingProvider.font,
                            color: AppSettings.colorPrimaryFont,
                            fontWeight: settingProvider.fontWeight),
                      ),
                      SelectCurrency(typeCoin: ['Countries', 'Cryptos']),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    coinProvider.typeCurrency.toLowerCase() == 'countries'
                        ? coins.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                color: AppSettings.colorPrimaryLigth,
                              ))
                            : _createdListCoins(
                                context,
                                coins,
                                coinProvider.typeCurrency,
                                size,
                                settingProvider)
                        : coins.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                color: AppSettings.colorPrimaryLigth,
                              ))
                            : _createdListCoins(
                                context,
                                coins,
                                coinProvider.typeCurrency,
                                size,
                                settingProvider)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createdListCoins(context, List<Coin> coins, String typeCurrency,
      Size size, SettingsProvider provider) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: AppSettings.colorPrimaryLigth.withOpacity(.8),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500]!,
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset.fromDirection(0, 0))
          ]),
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: size.height * 0.7,
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            var coin = coins[index];
            return Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              child: InkWell(
                onTap: () => {
                  Navigator.pushReplacementNamed(context, 'convert',
                      arguments: [coin, typeCurrency])
                },
                child: Row(
                  children: [
                    typeCurrency.toLowerCase() == 'countries'
                        ? Flag.fromString(
                            coin.codeFlag!,
                            fit: BoxFit.cover,
                            height: 40,
                            width: 50,
                            borderRadius: 12,
                          )
                        : Image.network(
                            coin.codeFlag!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      coin.name!,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: provider.fontWeight,
                          fontFamily: provider.font),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
                color: Colors.black38,
                thickness: 1.5,
              ),
          itemCount: coins.length),
    );
  }

  Widget _searchBar(Size size, SettingsProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: provider.backgroundSearch ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: TextField(
                controller: textController,
                style: TextStyle(
                    fontWeight: provider.fontWeight,
                    fontSize: 20,
                    fontFamily: provider.font,
                    color: AppSettings.colorPrimaryFont),
                maxLines: 1,
                cursorColor: AppSettings.colorPrimaryFont,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      color: Colors.grey[800],
                    ),
                    border: InputBorder.none,
                    hintStyle: provider.tStyleDefault,
                    hintText: 'Search Coin'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
