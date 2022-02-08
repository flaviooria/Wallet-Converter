import 'package:flutter/material.dart';
import 'package:pratica5/utils/AppSettings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options1 = ['Sistema', 'Luminoso', 'Oscuro'];
    final options2 = ['Sistema', 'Negrita'];
    final options3 = ['Sin máximo de dígitos', '2 digítos', '3 digítos'];

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
                  _title('previsualizar'),
                  _coinActual(),
                  _title('Apariencia'),
                  SelectOptionSettings(options: options1),
                  _title('Tamaño del Texto'),
                  SelectOptionSettings(options: options2),
                  _title('Digítos decimales'),
                  SelectOptionSettings(options: options3)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
          color: AppSettings.colorPrimary,
          fontFamily: AppSettings.fontTitle,
          fontWeight: FontWeight.w600),
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
  const SelectOptionSettings({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppSettings.colorPrimaryLigth,
          borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            var title = options[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(title,
                  style: TextStyle(
                      color: AppSettings.colorPrimary,
                      fontFamily: AppSettings.fontTitle,
                      fontWeight: FontWeight.w600)),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
                thickness: 2,
              ),
          itemCount: options.length),
    );
  }
}
