import 'package:flutter/material.dart';

import 'package:bottom_bar/bottom_bar.dart';
import 'package:pratica5/pages/pages.dart';
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
        children: [SearchCoinPage(), SettingsPage()],
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
            icon: Icon(
              Icons.price_change_outlined,
            ),
            title: Text('Convertidor', style: TextStyle(fontFamily: 'Gilroy')),
            activeColor: AppSettings.colorPrimaryFont,
          ),
          BottomBarItem(
            inactiveColor: AppSettings.colorPrimaryLigth,
            icon: Icon(
              Icons.settings_outlined,
            ),
            title: Text('Ajustes', style: TextStyle(fontFamily: 'Gilroy')),
            activeColor: AppSettings.colorPrimaryFont,
          ),
        ],
      ),
    );
  }
}
