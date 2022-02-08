import 'package:flutter/material.dart';
import 'package:pratica5/pages/convert_page.dart';
import 'package:pratica5/pages/pages.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => CoinProvider())],
        child: MaterialAppWithProvider());
  }
}

class MaterialAppWithProvider extends StatelessWidget {
  const MaterialAppWithProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),
      title: 'Wallet',
      initialRoute: 'intro',
      routes: {
        'intro': (_) => IntroPage(),
        'home': (_) => HomePage(),
        'convert': (_) => ConvertPage(),
        'searched': (_) => SearchCoinPage(),
        'settings': (_) => SettingsPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
