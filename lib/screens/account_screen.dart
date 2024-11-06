import 'package:buy_sell/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Account screen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Выполняем выход из аккаунта
                await FirebaseAuth.instance.signOut();
                // Возвращаемся к экрану авторизации
                Navigator.of(context).pushReplacementNamed(LoginScreen.id);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
