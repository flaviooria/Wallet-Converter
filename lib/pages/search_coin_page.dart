import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:pratica5/models/coin_countrie.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:pratica5/widget/select_currency.dart';
import 'package:provider/provider.dart';

class SearchCoinPage extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
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
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                _searchBar(size),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Select type currency',
                        style: TextStyle(
                            fontFamily: 'Gilroy Extra-Bold',
                            color: AppSettings.colorPrimaryFont,
                            fontWeight: FontWeight.w700),
                      ),
                      SelectCurrency(typeCoin: ['Countries', 'Cryptos']),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.8,
                  child: ListView(shrinkWrap: true, children: [
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
                                    context, coins, coinProvider.typeCurrency)
                            : coins.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: AppSettings.colorPrimaryLigth,
                                  ))
                                : _createdListCoins(
                                    context, coins, coinProvider.typeCurrency)
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createdListCoins(context, List<Coin> coins, String typeCurrency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        decoration: BoxDecoration(color: Colors.white70, boxShadow: [
          BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset.fromDirection(0, 10))
        ]),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        width: double.infinity,
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (_, int index) {
              var coin = coins[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () => {
                    textController.dispose(),
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
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy-ExtraBold'),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  color: Colors.black38,
                  thickness: 1.5,
                ),
            itemCount: coins.length),
      ),
    );
  }

  Widget _searchBar(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[350]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: TextField(
                controller: textController,
                style: TextStyle(fontSize: 20),
                maxLines: 1,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      color: Colors.grey[800],
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: AppSettings.colorPrimaryFont,
                        fontWeight: FontWeight.w600),
                    hintText: 'Search Coin'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
