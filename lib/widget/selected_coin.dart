import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:pratica5/models/coin.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/provider/settings_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:provider/provider.dart';

class SelectedCoin extends StatefulWidget {
  SelectedCoin(
      {Key? key,
      required this.coins,
      required this.size,
      required this.valueRate,
      required this.symbol,
      required this.typeCurrency,
      this.valueConversion,
      this.valueInputUser,
      this.isDesactive = false,
      this.coinID})
      : super(key: key);

  final List<Coin> coins;
  final Size size;
  String symbol;
  String? valueRate;
  String? coinID;
  bool isDesactive;
  String? valueInputUser;
  double? valueConversion;
  String typeCurrency;

  @override
  State<SelectedCoin> createState() => _SelectedCoinState();
}

class _SelectedCoinState extends State<SelectedCoin> {
  String? _coinIdSelected;
  String? rateCoinSelected;
  String? symbol;

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    //Si en ambas variables que es el valor de la moneda seleccionada y el simbolo son null
    //le indico la que tenga por defecto
    if (rateCoinSelected == null) {
      rateCoinSelected = widget.valueRate;
    }

    if (symbol == null) {
      symbol = widget.symbol;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IgnorePointer(
          ignoring: widget.isDesactive,
          child: DropdownButton(
            hint: Center(
              child: Text(
                'Escoge',
                style: settings.tStyleDefault,
              ),
            ),
            icon:
                widget.isDesactive //Esto es para desactivar el dropdown button
                    ? Container()
                    : Icon(
                        Icons.expand_more_rounded,
                        color: AppSettings.colorPrimaryFont,
                      ),
            underline: Container(),
            value: _coinIdSelected ?? widget.coinID,
            items: widget.coins.map((coin) {
              return DropdownMenuItem(
                value: coin.id,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.typeCurrency.toLowerCase() == 'countries'
                          ? Flag.fromString(
                              coin.codeFlag!,
                              fit: BoxFit.cover,
                              height: 40,
                              width: 50,
                              borderRadius: 12,
                            )
                          : Image.network(
                              coin.codeFlag!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 50,
                          child: Text(coin.name!,
                              style: settings.tStyleDefault,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false))
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                //Hago una copia de la lista de monedas donde obtendre el rate y simbolo que se seleccione
                final coinsCopy = [...widget.coins];

                final coin = coinsCopy.firstWhere((item) => item.id == value);
                rateCoinSelected = coin.rate.toString();
                symbol = coin.symbol;

                //Añado la moneda seleccionada al provider para ser utilizada despues para su conversión
                coinProvider.setCoinToConverted(coin);
                coinProvider.setCoinValueConversion(null);
                //Igualo el id del coin a la variable coinIDSelected
                _coinIdSelected = value.toString();
              });
            },
          ),
        ),
        Container(
          width: widget.size.width * 0.4,
          height: widget.size.height * 0.05,
          decoration: BoxDecoration(
              color: AppSettings.colorPrimaryLigth,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.valueConversion == null || widget.valueConversion == ''
                    ? widget.valueInputUser == '' ||
                            widget.valueInputUser == null
                        ? Text(
                            rateCoinSelected == '' || rateCoinSelected == null
                                ? '0.00 ${symbol}'
                                : '$rateCoinSelected $symbol.',
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: settings.fontWeight,
                                color: AppSettings.colorPrimary),
                          )
                        : Text(
                            '${widget.valueInputUser} $symbol.',
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: settings.fontWeight,
                                color: AppSettings.colorPrimary),
                          )
                    : Text(
                        '${widget.valueConversion!.toStringAsFixed(settings.numberDigits!)} $symbol.',
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: settings.fontWeight,
                            color: AppSettings.colorPrimary),
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
