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

class HomeScreen extends StatefulWidget {
  User? user = FirebaseAuth.instance.currentUser;
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  final List<Widget> _pageOptions = [
    HomeScreenContent(),
    FavoriteScreen(),
    MyAddScreen(),
    AccountScreen()
  ];

  String address = 'Russia';

  get googleService => null;

  Future<String?> getAddress() async {
    final coordinates = new Coordinates(1.10, 45.50);
    var addresses =
        await googleService.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      addresses = first.addressLine as List<Address>;
    });

    setState(() {
      address = first.addressLine;
    });

    return first.addressLine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.cyan.shade600,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.favorite, title: 'favorite'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
      body: _pageOptions[selectedPage],
    );
  }
}

// Создаем отдельный виджет для содержимого начального экрана
class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                Icon(Icons.notifications_none),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Column(
            children: [
              BannerWidget(),
              CategoryWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
