import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:pratica5/models/coin_countrie.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:provider/provider.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinCountrieProvider>(context);
    final coin = ModalRoute.of(context)!.settings.arguments as CoinCountrie;
    final coinCoverted = coinProvider.coinToConverted;
    final valueConversion = coinProvider.valueCoinConversion;

    final size = MediaQuery.of(context).size;
    final list_coinsPrimary = coinProvider.coins;
    final list_coinsSecondary =
        [...coinProvider.coins].where((item) => item.id != coin.id).toList();

    return Scaffold(
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'home');
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SelectedCoin(
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
                  provider: coinProvider),
            ),
            Positioned(
              width: size.width * 0.9,
              top: size.height * 0.55,
              left: size.width * 0.05,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    renderRow(['7', '8', '9']),
                    renderRow(['4', '5', '6']),
                    renderRow(['1', '2', '3']),
                    renderRowFunctionals()
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Container _btnConvert(Size size) {
    return Container(
      width: size.width * 0.5,
      height: size.height * 0.08,
      decoration: BoxDecoration(
          color: AppSettings.colorPrimaryFont,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(
        'Convert'.toUpperCase(),
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppSettings.colorPrimary),
      )),
    );
  }

  Widget renderRowFunctionals() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _renderNumberSelected('0'),
            _renderNumberSelected('.'),
            _deleteNumber()
          ],
        ));
  }

  Widget renderRow(List numbers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: numbers.map((num) => _renderNumberSelected(num)).toList()),
    );
  }

  Widget _convertBtn(
    Size size, {
    required CoinCountrie coinActual,
    required CoinCountrie? coinConverted,
    required CoinCountrieProvider provider,
  }) {
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
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppSettings.colorPrimary),
      )),
    );
  }

  MaterialButton _renderNumberSelected(String numberPulseInScreen) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minWidth: 80,
      height: 80,
      color: AppSettings.colorPrimaryLigth,
      splashColor: AppSettings.colorSecondary,
      onPressed: () {
        setState(() {
          /**
           * Valido si el text está vacio y si la tecla es el .
           * si es asi no escribe.
           */

          if (textController.text == '' &&
              numberPulseInScreen == '.' &&
              numberPulseInScreen == '0') {
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
            fontSize: 24.0,
            color: AppSettings.colorPrimary,
            fontWeight: FontWeight.w600),
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

class SelectedCoin extends StatefulWidget {
  SelectedCoin(
      {Key? key,
      required this.coins,
      required this.size,
      required this.valueRate,
      required this.symbol,
      this.valueConversion,
      this.valueInputUser,
      this.isDesactive = false,
      this.coinID})
      : super(key: key);

  final List<CoinCountrie> coins;
  final Size size;
  String symbol;
  String? valueRate;
  String? coinID;
  bool isDesactive;
  String? valueInputUser;
  double? valueConversion;

  @override
  State<SelectedCoin> createState() => _SelectedCoinState();
}

class _SelectedCoinState extends State<SelectedCoin> {
  String? _coinIdSelected;
  String? rateCoinSelected;
  String? symbol;

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinCountrieProvider>(context);
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
              child: Text('Escoge'),
            ),
            icon:
                widget.isDesactive //Esto es para desactivar el dropdown button
                    ? Container()
                    : Icon(
                        Icons.expand_more_rounded,
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
                      Flag.fromString(
                        coin.codeFlag!,
                        height: 40,
                        width: 50,
                        fit: BoxFit.cover,
                        borderRadius: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 50,
                          child: Text(coin.name!,
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
                                fontWeight: FontWeight.w600,
                                color: AppSettings.colorPrimary),
                          )
                        : Text(
                            '${widget.valueInputUser} $symbol.',
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppSettings.colorPrimary),
                          )
                    : Text(
                        '${widget.valueConversion!.toStringAsFixed(4)} $symbol.',
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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

class selectItems extends StatelessWidget {
  const selectItems({
    Key? key,
    required this.typeCoin,
  }) : super(key: key);

  final List<String> typeCoin;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      onChanged: (value) {},
      onTap: () {
        print('tap');
      },
      underline: Container(
        height: 2,
        color: AppSettings.colorPrimaryLigth,
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Gilroy-ExtraBold',
          color: AppSettings.colorPrimaryFont),
      value: typeCoin[0],
      items: typeCoin.map((coin) {
        return DropdownMenuItem(
          child: Text(coin),
          value: coin,
        );
      }).toList(),
    );
  }
}
