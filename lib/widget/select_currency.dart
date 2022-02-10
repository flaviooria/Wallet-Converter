import 'package:flutter/material.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/provider/setttings_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:provider/provider.dart';

class SelectCurrency extends StatelessWidget {
  SelectCurrency({
    Key? key,
    required this.typeCoin,
  }) : super(key: key);

  final List<String> typeCoin;

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    final settingProvider = Provider.of<SettingsProvider>(context);

    return DropdownButton(
      borderRadius: BorderRadius.circular(20),
      onChanged: (value) {
        coinProvider.setTypeCurrency(value.toString());
      },
      underline: Container(
        height: 2,
        color: AppSettings.colorPrimaryLigth,
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
      style: TextStyle(
          fontWeight: settingProvider.fontWeight,
          fontFamily: settingProvider.font,
          color: AppSettings.colorPrimaryFont),
      value: coinProvider.typeCurrency,
      items: typeCoin.map((coin) {
        return DropdownMenuItem(
          child: Text(coin),
          value: coin,
        );
      }).toList(),
    );
  }
}
