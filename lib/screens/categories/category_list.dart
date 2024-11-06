import 'package:buy_sell/screens/categories/subCat_screen.dart';
import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatelessWidget {
  static const String id = 'category-list-screen';

  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices sevice = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: sevice.categories.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        if (doc?['subCat'] == null) {
                          return print('No sub Categories');
                        }
                        Navigator.pushNamed(context, SubCatList.id,
                            arguments: doc);
                      },
                      leading: Image.network(
                        doc?['image'],
                        width: 40,
                      ),
                      title: Text(
                        doc?['catName'],
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: const Icon(
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
