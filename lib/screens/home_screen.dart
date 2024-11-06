import 'package:buy_sell/screens/location_screen.dart';
import 'package:buy_sell/screens/myAdd_screen.dart';
import 'package:buy_sell/screens/widgets/banner_widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_plus/geocoder_plus.dart';
import 'widgets/category_widget.dart';
import 'favorite_screen.dart';
import 'account_screen.dart';

// Главный экран приложения, который содержит нижнюю панель навигации и отображает содержимое на основе выбранного экрана
class HomeScreen extends StatefulWidget {
  User? user = FirebaseAuth
      .instance.currentUser; // Получаем текущего пользователя Firebase
  static const String id = 'home-screen'; // Уникальный ID экрана для навигации

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0; // Индекс выбранной страницы
  final List<Widget> _pageOptions = [
    HomeScreenContent(), // Главная страница контента
    FavoriteScreen(), // Экран избранного
    MyAddScreen(), // Экран добавления объявлений
    AccountScreen() // Экран профиля
  ];

  String address = 'Russia'; // Начальное значение адреса

  get googleService => null; // Заглушка для сервиса Google

  // Метод для получения адреса по координатам
  Future<String?> getAddress() async {
    final coordinates = Coordinates(1.10, 45.50); // Пример координат
    var addresses =
        await googleService.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      addresses = first.addressLine
          as List<Address>; // Обновление адресов (необходимо исправить)
    });

    setState(() {
      address = first.addressLine; // Установка полученного адреса
    });

    return first.addressLine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Нижняя панель навигации с ConvexAppBar
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.cyan.shade600,
        items: [
          TabItem(icon: Icons.home, title: 'Home'), // Вкладка Главная
          TabItem(icon: Icons.favorite, title: 'Favorite'), // Вкладка Избранное
          TabItem(icon: Icons.add, title: 'Add'), // Вкладка Добавить
          TabItem(icon: Icons.people, title: 'Profile'), // Вкладка Профиль
        ],
        initialActiveIndex: selectedPage, // Начальная активная вкладка
        onTap: (int index) {
          setState(() {
            selectedPage = index; // Обновление активной вкладки
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        // Кнопка выбора местоположения с переходом на экран LocationScreen
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, LocationScreen.id);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.black,
                    size: 18,
                  ),
                  Flexible(
                    child: Text(
                      address,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _pageOptions[selectedPage], // Отображение текущей активной страницы
    );
  }
}

// Виджет с основным содержимым начального экрана
class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Панель поиска с иконкой уведомлений
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        labelText: 'What are you looking for?',
                        labelStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.notifications_none), // Иконка уведомлений
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Column(
            children: [
              BannerWidget(), // Баннер виджет
              CategoryWidget(), // Виджет категорий
            ],
          ),
        ),
      ],
    );
  }
}
