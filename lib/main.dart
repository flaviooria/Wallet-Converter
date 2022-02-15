import 'package:flutter/material.dart';
import 'package:pratica5/pages/convert_page.dart';
import 'package:pratica5/pages/pages.dart';
import 'package:pratica5/provider/coin_provider.dart';
import 'package:pratica5/provider/settings_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CoinProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider())
    ], child: MaterialAppWithProvider());
  }
}

class MaterialAppWithProvider extends StatelessWidget {
  const MaterialAppWithProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsProvider.typeTheme,
      title: 'Wallet',
      initialRoute: 'intro',
      routes: {
        'intro': (_) =>
            settingsProvider.isFirstViewIntro! ? IntroPage() : HomePage(),
        'home': (_) => HomePage(),
        'convert': (_) => ConvertPage(),
        'searched': (_) => SearchCoinPage(),
        'settings': (_) => SettingsPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
