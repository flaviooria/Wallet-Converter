import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:pratica5/pages/convert_page.dart';
import 'package:pratica5/pages/search_coin_page.dart';
import 'package:pratica5/utils/AppSettings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        //Sirve para desactivar el swipe
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [SearchCoinPage()],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            inactiveColor: AppSettings.colorPrimaryLigth,
            icon: Icon(Icons.home),
            title: Text('Inicio'),
            activeColor: AppSettings.colorPrimaryFont,
          ),
          BottomBarItem(
            inactiveColor: AppSettings.colorPrimaryLigth,
            icon: Icon(
              Icons.price_change_outlined,
            ),
            title: Text('Convertidor'),
            activeColor: AppSettings.colorPrimaryFont,
          ),
          BottomBarItem(
            inactiveColor: AppSettings.colorPrimaryLigth,
            icon: Icon(
              Icons.settings_outlined,
            ),
            title: Text('Ajustes'),
            activeColor: AppSettings.colorPrimaryFont,
          ),
        ],
      ),
    );
  }
}
