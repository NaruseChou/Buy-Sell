import 'package:buy_sell/screens/SellItems/seller_category.dart';
import 'package:flutter/material.dart';

class MyAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, SellerCategory.id);
          },
          child: Text(
            'Create\nannouncements',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
