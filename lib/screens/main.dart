import 'package:buy_sell/forms/seller_car_form.dart';
import 'package:buy_sell/provider/cat_provider.dart';
import 'package:buy_sell/screens/SellItems/Seller_subCat.dart';
import 'package:buy_sell/screens/SellItems/seller_category.dart';
import 'package:buy_sell/screens/authentication/phoneauth_screen.dart';
import 'package:buy_sell/screens/categories/category_list.dart';
import 'package:buy_sell/screens/categories/subCat_screen.dart';
import 'package:buy_sell/screens/home_screen.dart';
import 'package:buy_sell/screens/location_screen.dart';
import 'package:buy_sell/screens/login_screen.dart';
import 'package:buy_sell/screens/main_screen.dart';
import 'package:buy_sell/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => CategoryProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade700,
      ),
      initialRoute: SplashScreen.id,
      routes: <String, WidgetBuilder>{
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCatList.id: (context) => SubCatList(),
        HomeScreen.id: (context) => HomeScreen(),
        SellerSubcat.id: (context) => SellerSubcat(),
        SellerCategory.id: (context) => SellerCategory(),
        SellerCarForm.id: (context) => SellerCarForm()
      },
    );
  }
}
