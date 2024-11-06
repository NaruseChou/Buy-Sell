import 'package:buy_sell/forms/seller_car_form.dart';
import 'package:buy_sell/provider/cat_provider.dart';
import 'package:buy_sell/screens/SellItems/Seller_subCat.dart';
import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Экран выбора категории для продавца
class SellerCategory extends StatelessWidget {
  // Идентификатор экрана, используемый для навигации
  static const String id = 'Seller-category-list-screen';

  @override
  Widget build(BuildContext context) {
    // Инициализация экземпляра FirebaseServices для работы с Firebase
    FirebaseServices sevice = FirebaseServices();

    // Доступ к провайдеру категорий, чтобы получать и устанавливать выбранные данные
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      // Верхняя панель приложения (AppBar) с заголовком
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Choose Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        // FutureBuilder для получения списка категорий из Firebase Firestore
        child: FutureBuilder<QuerySnapshot>(
          // Запрос для получения данных о категориях, отсортированных по полю `sortId`
          future: sevice.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Обработка ошибок при получении данных
            if (snapshot.hasError) {
              return Container();
            }

            // Показывает индикатор загрузки, пока данные загружаются
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Список категорий после успешного получения данных
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      // При нажатии на элемент списка происходит навигация
                      onTap: () {
                        // Установка выбранной категории и документа в провайдер
                        _catProvider.getCategory(doc?['catName']);
                        _catProvider.getCatSnapshot(doc);

                        // Проверка, есть ли подкатегории в категории
                        if (doc?['subCat'] == null) {
                          // Если подкатегорий нет, переходим к форме `SellerCarForm`
                          Navigator.pushNamed(context, SellerCarForm.id);
                        } else {
                          // В противном случае переходим к экрану подкатегорий `SellerSubcat`
                          Navigator.pushNamed(context, SellerSubcat.id,
                              arguments: doc);
                        }
                      },
                      // Изображение категории
                      leading: Image.network(
                        doc?['image'] ??
                            '', // Если изображение отсутствует, используется пустая строка
                        width: 40,
                      ),
                      // Название категории
                      title: Text(
                        doc?['catName'] ??
                            '', // Если название отсутствует, используется пустая строка
                        style: const TextStyle(fontSize: 15),
                      ),
                      // Значок стрелки, если у категории есть подкатегории
                      trailing: doc?['subCat'] == null
                          ? null
                          : Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
