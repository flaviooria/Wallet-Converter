import 'package:flutter/material.dart';
import 'package:pratica5/provider/settings_provider.dart';
import 'package:pratica5/utils/AppSettings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingsProvider>(context);

    final appearance = ['System', 'Ligth', 'Dark'];
    final textsytles = ['Normal', 'Text Black'];
    final numdigits = ['No maximum digits', '2 digits', '3 digits'];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  _title('preview', settingProvider),
                  _coinActual(),
                  _title('appearance', settingProvider),
                  SelectOptionSettings(
                    items: appearance,
                    typeSettigs: 0,
                    settingsProvider: settingProvider,
                  ),
                  _title('text size', settingProvider),
                  SelectOptionSettings(
                    items: textsytles,
                    settingsProvider: settingProvider,
                    typeSettigs: 1,
                  ),
                  _title('decimal digits', settingProvider),
                  SelectOptionSettings(
                    items: numdigits,
                    settingsProvider: settingProvider,
                    typeSettigs: 2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String title, SettingsProvider settingsProvider) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
          color: AppSettings.colorPrimary,
          fontFamily: settingsProvider.font,
          fontWeight: settingsProvider.fontWeight),
    );
  }

  Widget _coinActual() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppSettings.colorPrimaryLigth,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://seeklogo.com/images/E/Euro-logo-FC4B33E4DA-seeklogo.com.png',
              width: 50,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EUR',
                  style: TextStyle(
                      color: AppSettings.colorPrimary,
                      fontFamily: AppSettings.fontTitle,
                      fontWeight: FontWeight.w600)),
              Text('Euro',
                  style: TextStyle(
                      color: AppSettings.colorPrimary,
                      fontFamily: AppSettings.fontTitle,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppSettings.colorPrimaryFont,
                borderRadius: BorderRadius.circular(12)),
            child: Text('52.00 €',
                style: TextStyle(
                    color: AppSettings.colorPrimary,
                    fontFamily: AppSettings.fontTitle,
                    fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class SelectOptionSettings extends StatelessWidget {
  const SelectOptionSettings(
      {Key? key,
      required this.typeSettigs,
      required this.items,
      required this.settingsProvider})
      : super(key: key);

  final SettingsProvider settingsProvider;
  final List<String> items;
  final int typeSettigs;
  @override
  Widget build(BuildContext context) {
    final provider = settingsProvider;
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppSettings.colorPrimaryLigth,
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: data(provider, typeSettigs)));
  }

  List<Widget> data(SettingsProvider provider, int typeSettings) {
    List<Widget> settings = [];
    for (var i = 0; i < items.length; i++) {
      var title = items[i];
      var type;
      var typeSelected;

      //Theme
      if (typeSettigs == 0) {
        type = provider.themeOptions[i];
        typeSelected = provider.typeTheme;
      }
      //Text Style
      if (typeSettigs == 1) {
        type = provider.styleTextOptions[i];
        typeSelected = provider.typeText;
      }
      //Number digits
      if (typeSettigs == 2) {
        type = provider.numberDigitsOptions[i];
        typeSelected = provider.typeDigits;
      }

      settings
        ..add(InkWell(
          onTap: () {
            switch (typeSettings) {
              case 0:
                provider.setTheme(type);
                break;
              case 1:
                provider.setTextStyle(type);
                break;
              case 2:
                provider.setNumberDigits(type);
                break;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(title,
                    style: TextStyle(
                        color: AppSettings.colorPrimary,
                        fontFamily: provider.font,
                        fontWeight: provider.fontWeight)),
              ),
              typeSelected == type
                  ? Icon(
                      Icons.done_rounded,
                      color: Colors.green,
                    )
                  : Text('')
            ],
          ),
        ))
        ..add(Divider(
          color: Colors.grey[500]?.withOpacity(.3),
          thickness: 1.5,
        ));
    }

    return settings;
  }
}
