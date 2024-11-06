import 'package:buy_sell/provider/cat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  static const String id = 'car-form';

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();

  validate() {
    if (_formKey.currentState!.validate()) {
      print('Validated');
    }
  }

  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldValue) {
      return AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text(
          '$title > $fieldValue',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _catProvider.doc['models'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _brandController.text =
                              _catProvider.doc['models'][index];
                        });
                        Navigator.pop(context);
                      },
                      title: Text(_catProvider.doc['models'][index]),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _brandList();
                        });
                  },
                  child: TextFormField(
                    controller: _brandController,
                    enabled: false,
                    decoration:
                        InputDecoration(labelText: 'Brand / Model / Variant*'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                ),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Year*',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Price*', prefixText: 'Rub: '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field';
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listView(
                              fieldValue: 'Fuel',
                              list: _fuelList,
                              textController: _fuelController);
                        });
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: _fuelController,
                    decoration: InputDecoration(
                      labelText: 'Fuel*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  validate();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
