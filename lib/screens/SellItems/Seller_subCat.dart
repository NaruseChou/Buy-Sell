import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerSubcat extends StatelessWidget {
  static const String id = 'seller-subCat-screen';

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? args = ModalRoute.of(context)!.settings.arguments
        as DocumentSnapshot<Object?>?;
    FirebaseServices sevice = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          args?['catName'],
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: sevice.categories.doc(args?.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data?['subCat'];
            return Container(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        data?[index],
                        style: const TextStyle(fontSize: 15),
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
