import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buy_sell/screens/location_screen.dart';
import 'package:buy_sell/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Экран загрузки
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash-screen'; // ID для навигации

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Таймер на 3 секунды, после чего определяется состояние авторизации
    Timer(
      const Duration(seconds: 3),
      () {
        var listen = FirebaseAuth.instance.authStateChanges().listen(
          (User? user) {
            if (user == null) {
              // Если пользователь не авторизован, переходим на экран входа
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            } else {
              // Если пользователь авторизован, переходим на экран локации
              Navigator.pushReplacementNamed(context, LocationScreen.id);
            }
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Определяем цвета для анимированного текста
    const colorizeColors = [
      Colors.white,
      Colors.grey,
    ];

    // Стиль текста для анимации
    const colorizeTextStyle = TextStyle(
      fontSize: 30.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
      backgroundColor: Colors.cyan.shade700, // Фон экрана загрузки
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10, // Отступ сверху
            ),
            // Анимированный текст "Buy or Sell" с изменяющимися цветами
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Buy or Sell', // Текст анимации
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event"); // Событие при нажатии на текст
              },
            ),
          ],
        ),
      ),
    );
  }
}
