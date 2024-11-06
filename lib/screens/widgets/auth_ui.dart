import 'package:buy_sell/screens/authentication/phoneauth_screen.dart';
import 'package:flutter/material.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                  // ignore: deprecated_member_use
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Navigator.pushNamed(context, PhoneAuthScreen.id);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Continue with Phone',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
