import 'package:buy_sell/provider/cat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

// Экран формы для добавления автомобиля
class SellerCarForm extends StatefulWidget {
  static const String id = 'car-form';

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  // Ключ для управления формой и валидацией
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для текстовых полей ввода
  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _descController = TextEditingController();
  var _addressController = TextEditingController();

  // Функция для проверки валидности формы
  validate() {
    if (_formKey.currentState!.validate()) {
      print('Validated');
    }
  }

  // Списки опций для выбора топлива, типа коробки передач и количества владельцев
  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  List<String> _transmission = ['Manually', 'Automatic'];
  List<String> _noOfOwner = ['1', '2', '3', '4', '4+'];

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    // Функция для отображения AppBar с выбранной категорией и полем
    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        title: Text(
          '$title > $fieldValue',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    // Диалог для выбора бренда автомобиля
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

    // Универсальный диалог для выбора из списка (например, тип топлива или коробки передач)
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок категории
                  Text(
                    'CAR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Поле выбора бренда/модели автомобиля
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
                      decoration: InputDecoration(
                          labelText: 'Brand / Model / Variant*'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Поле ввода года выпуска
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
                  // Поле ввода цены
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Price*', prefixText: 'Rub: '),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  // Поле выбора типа топлива
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
                  // Поле выбора типа коробки передач
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Transmission',
                                list: _transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      decoration: InputDecoration(
                        labelText: 'Transmission*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Поле ввода пробега
                  TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'KM Driven*'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  // Поле выбора количества владельцев
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'No. of owners',
                                list: _noOfOwner,
                                textController: _noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      decoration: InputDecoration(
                        labelText: 'No. of owners*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Поле ввода заголовка объявления
                  TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    maxLength: 50,
                    decoration: InputDecoration(
                        labelText: 'Add title*',
                        counterText:
                            'Mention the key features (e.g brand, model)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  // Поле ввода описания автомобиля
                  TextFormField(
                    controller: _descController,
                    keyboardType: TextInputType.number,
                    maxLength: 4000,
                    decoration: InputDecoration(
                        labelText: 'Description*',
                        counterText:
                            'Include condition, features, reason for selling'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Кнопка для подтверждения формы
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            validate();
                          },
                          child: Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
