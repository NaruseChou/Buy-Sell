// MainScreen.dart
import 'package:buy_sell/screens/account_screen.dart';
import 'package:buy_sell/screens/home_screen.dart';
import 'package:buy_sell/screens/favorite_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedpage = 0;
  final List<Widget> _pageOptions = [
    HomeScreen(), // Главный экран
    FavoriteScreen(), // Экран для добавления объявлений
    AccountScreen(), // Экран профиля
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[selectedpage], // Выбранный экран отображается здесь
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.cyan,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: selectedpage,
        onTap: (int index) {
          setState(() {
            selectedpage = index;
          });
        },
      ),
    );
  }
}
