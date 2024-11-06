import 'package:buy_sell/screens/authentication/otp_screen.dart';
import 'package:buy_sell/screens/location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Сервис для аутентификации через номер телефона
class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth
      .instance; // Экземпляр FirebaseAuth для работы с Firebase аутентификацией
  User? user =
      FirebaseAuth.instance.currentUser; // Текущий пользователь Firebase

  // Ссылка на коллекцию 'users' в Firestore
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Метод для добавления пользователя в Firestore, если его нет
  Future<void> addUser(BuildContext context, String uid) async {
    // Проверка, есть ли уже пользователь с данным UID в Firestore
    final QuerySnapshot<Object?> result =
        await users.where('uid', isEqualTo: user?.uid).get();

    List<DocumentSnapshot> document = result.docs; // Получаем список документов

    if (document.isNotEmpty) {
      // Если пользователь существует, переходим на экран выбора локации
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else {
      // Если пользователя нет, добавляем его данные в Firestore
      return users.doc(user?.uid).set({
        'uid': user?.uid,
        'mobile': user?.phoneNumber, // Сохраняем UID и номер телефона
      }).then((value) {
        // Переходим на экран выбора локации после успешного добавления
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      })
          // Обработка ошибок при добавлении
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  // Метод для верификации номера телефона
  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    // Callback для завершения верификации
    verificationCompleted(PhoneAuthCredential credential) async {
      await auth.signInWithCredential(
          credential); // Выполняем вход с использованием полученных учетных данных
    }

    // Callback для обработки ошибок при верификации
    verificationFailed(FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print(
            'The provided phone number is not valid.'); // Неверный номер телефона
      }
      print('The error is ${e.code}');
    }

    // Callback при успешной отправке кода подтверждения
    codeSent(String verId, int? resendToken) async {
      // Переход на экран ввода кода подтверждения (OTP)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number, // Передаем номер телефона
            verId: verId, // Идентификатор для подтверждения кода
          ),
        ),
      );
    }

    try {
      // Инициализация процесса верификации номера телефона
      auth.verifyPhoneNumber(
          phoneNumber: number, // Номер телефона для верификации
          verificationCompleted:
              verificationCompleted, // Автоматическая верификация
          verificationFailed: verificationFailed, // Обработка ошибок
          codeSent: codeSent, // Отправка кода подтверждения
          timeout: const Duration(seconds: 60), // Тайм-аут для ожидания кода
          codeAutoRetrievalTimeout: (String verificationId) {
            print(verificationId); // Callback при истечении тайм-аута
          });
    } catch (e) {
      print('Error ${e.toString()}'); // Обработка исключений
    }
  }
}
