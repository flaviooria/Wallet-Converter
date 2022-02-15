import 'package:flutter/material.dart';

import 'package:pratica5/models/coin.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:pratica5/widget/selected_coin.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  GlobalKey<FormState> _homeKey =
      GlobalKey<FormState>(debugLabel: '_homeScreenkey');
  var textController;
  @override
  void initState() {
    // TODO: implement initState
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    final settingProvider = Provider.of<SettingsProvider>(context);

    final data = ModalRoute.of(context)!.settings.arguments as List;
    final coin = data[0] as Coin;
    final typeCurrency = data[1] as String;
    final coinCoverted = coinProvider.coinToConverted;
    final valueConversion = coinProvider.valueCoinConversion;
    final size = MediaQuery.of(context).size;
    final list_coinsPrimary;
    final list_coinsSecondary;
    if (typeCurrency.toLowerCase() == 'countries') {
      list_coinsPrimary = coinProvider.coinsCountries;
      list_coinsSecondary = [...coinProvider.coinsCountries]
          .where((item) => item.id != coin.id)
          .toList();
    } else {
      list_coinsPrimary = coinProvider.coinsCryptos;
      list_coinsSecondary = [...coinProvider.coinsCryptos]
          .where((item) => item.id != coin.id)
          .toList();
    }

    return Scaffold(
      key: _homeKey,
      body: Container(
        height: 1000,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              decoration: BoxDecoration(
                  color: AppSettings.colorPrimaryFont,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                      bottomLeft: Radius.circular(80))),
            ),
            Positioned(
              width: size.width * 0.9,
              top: size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      coinProvider.setCoinToConverted(null);
                      coinProvider.setCoinValueConversion(null);
                      Future(() => Navigator.pushNamed(context, 'home'));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.05,
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.35,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SelectedCoin(
                        typeCurrency: typeCurrency,
                        symbol: coin.symbol!,
                        isDesactive: true,
                        coins: list_coinsPrimary,
                        size: size,
                        valueRate: '1.00',
                        coinID: coin.id,
                        valueInputUser: textController.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SelectedCoin(
                        typeCurrency: typeCurrency,
                        symbol: '',
                        coins: list_coinsSecondary,
                        size: size,
                        valueRate: '',
                        valueConversion: valueConversion,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.45,
              left: size.width * 0.25,
              child: _convertBtn(size,
                  coinActual: coin,
                  coinConverted: coinCoverted,
                  provider: coinProvider,
                  settingsProvider: settingProvider),
            ),
            Positioned(
              width: size.width * 0.9,
              top: size.height * 0.55,
              left: size.width * 0.05,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    renderRow(['7', '8', '9'], settingProvider),
                    renderRow(['4', '5', '6'], settingProvider),
                    renderRow(['1', '2', '3'], settingProvider),
                    renderRowFunctionals(settingProvider)
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget renderRowFunctionals(SettingsProvider settingsProvider) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _renderNumberSelected('0', settingsProvider),
            _renderNumberSelected('.', settingsProvider),
            _deleteNumber()
          ],
        ));
  }

  Widget renderRow(List numbers, SettingsProvider settingsProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: numbers
              .map((num) => _renderNumberSelected(num, settingsProvider))
              .toList()),
    );
  }

  Widget _convertBtn(Size size,
      {required Coin coinActual,
      required Coin? coinConverted,
      required CoinProvider provider,
      required SettingsProvider settingsProvider}) {
    return MaterialButton(
      onPressed: () {
        if (coinConverted != null) {
          setState(() {
            print(coinActual.rate);
            print(coinConverted.rate);
            final rate = coinActual.rate;
            final double amount = textController.text == ''
                ? 1.0
                : double.parse(textController.text);

            final conversion = (rate! * amount) / coinConverted.rate!;
            provider.setCoinValueConversion(conversion);
          });
        }
      },
      animationDuration: Duration(milliseconds: 1500),
      minWidth: size.width * 0.5,
      height: size.height * 0.08,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: AppSettings.colorPrimaryFont,
      splashColor: AppSettings.colorSecondary,
      child: Center(
          child: Text(
        'Convert'.toUpperCase(),
        style: TextStyle(
            fontFamily: settingsProvider.font,
            fontSize: 20,
            fontWeight: settingsProvider.fontWeight,
            color: AppSettings.colorPrimary),
      )),
    );
  }

  MaterialButton _renderNumberSelected(
      String numberPulseInScreen, SettingsProvider settingsProvider) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minWidth: 80,
      height: 80,
      color: AppSettings.colorPrimaryLigth,
      splashColor: AppSettings.colorSecondary,
      onPressed: () {
        setState(() {
          /**
           * Valido si el text está vacio y si la tecla es el . y si es 0
           * si es asi no escribe.
           */

          if (textController.text == '' && numberPulseInScreen == '.' ||
              textController.text == '' && numberPulseInScreen == '0') {
            textController.text = '';
          } else {
            /**
             * Si sale que es -1, es porque no se ha escrito nigún punto.
             */
            if (textController.text.indexOf('.') == -1) {
              textController.text += numberPulseInScreen;
            } else if (numberPulseInScreen != '.') {
              textController.text += numberPulseInScreen;
            }
          }
        });
      },
      child: Text(
        numberPulseInScreen,
        style: TextStyle(
            fontFamily: settingsProvider.font,
            fontSize: 24.0,
            color: AppSettings.colorPrimary,
            fontWeight: settingsProvider.fontWeight),
      ),
    );
  }

  MaterialButton _deleteNumber() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      height: 80,
      color: AppSettings.colorPrimaryLigth,
      splashColor: AppSettings.colorSecondary,
      onLongPress: () {
        setState(() {
          if (textController.text != '') {
            textController.text = textController.text
                .substring(0, (textController.text.length - 1));
          }
        });
      },
      onPressed: () {
        setState(() {
          if (textController.text != '') {
            textController.text = textController.text
                .substring(0, (textController.text.length - 1));
          }
        });
      },
      child: Icon(
        Icons.backspace,
        color: AppSettings.colorPrimary,
      ),
    );
  }
}
