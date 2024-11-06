import 'package:buy_sell/screens/home_screen.dart';
import 'package:buy_sell/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> updateUser(Map<String, dynamic> data, context) async {
    return users.doc(user?.uid).update(data).then(
      (value) {
        Navigator.pushNamed(context, HomeScreen.id);
      },
    );
  }
}
