import 'package:buy_sell/screens/location_screen.dart';
import 'package:buy_sell/screens/widgets/auth_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan.shade700,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Text(
                      'Buy or Sell',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade700),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: const AuthUi(),
              ),
            ),
          ],
        ));
  }
}
