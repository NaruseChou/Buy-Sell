import 'package:buy_sell/screens/categories/category_list.dart';
import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices service = FirebaseServices();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: service.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return SizedBox(
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Categories')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CategoryListScreen.id);
                        },
                        child: const Row(
                          children: [
                            Text(
                              'See all',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data?.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 65,
                            height: 50,
                            child: Column(
                              children: [
                                Image.network(doc?['image']),
                                Flexible(
                                  child: Text(
                                    doc?['catName'],
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
