import 'package:buy_sell/forms/seller_car_form.dart';
import 'package:buy_sell/provider/cat_provider.dart';
import 'package:buy_sell/screens/SellItems/Seller_subCat.dart';
import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerCategory extends StatelessWidget {
  static const String id = 'Seller-category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseServices sevice = FirebaseServices();

    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
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
        child: FutureBuilder<QuerySnapshot>(
          future: sevice.categories.orderBy('sortId', descending: false).get(),
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
                        _catProvider.getCategory(doc?['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if (doc?['subCat'] == null) {
                          // If `subCat` is null, navigate to `SellerCarForm`
                          Navigator.pushNamed(context, SellerCarForm.id);
                        } else {
                          // Otherwise, navigate to `SellerSubcat`
                          Navigator.pushNamed(context, SellerSubcat.id,
                              arguments: doc);
                        }
                      },
                      leading: Image.network(
                        doc?['image'] ??
                            '', // Add a default empty string to prevent errors
                        width: 40,
                      ),
                      title: Text(
                        doc?['catName'] ??
                            '', // Add a default empty string to prevent errors
                        style: const TextStyle(fontSize: 15),
                      ),
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
