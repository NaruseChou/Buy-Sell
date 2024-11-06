import 'package:buy_sell/screens/home_screen.dart';
import 'package:buy_sell/screens/main_screen.dart';
import 'package:buy_sell/screens/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_plus/geocoder_plus.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final FirebaseServices _services = FirebaseServices();

  bool _loading = false;
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late String _address;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String manualAddress = "";

  get googleService => null;

  Future<LocationData?> getLocation() async {
    /*var latitude = _locationData.latitude;
    var longitude = _locationData.longitude;
    final coordinates = new Coordinates(latitude!, longitude!);
    var addresses =
        await googleService.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      addresses = first.addressLine as List<Address>;
    });*/
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    _services.users
        .doc(_services.user?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot['address'] != null) {
          setState(() {
            _loading = true;
          });
          Navigator.pushReplacementNamed(context, MainScreen.id);
        } else {
          setState(() {
            _loading = false;
          });
        }
      }
    });

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    showBottomScreen(context) {
      getLocation().then((location) {
        if (location != null) {
          progressDialog.dismiss();
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    SizedBox(
                      height: 26,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(color: Colors.black),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(6)),
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search City, area',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        getLocation().then((value) {
                          if (value != null) {
                            var latitude = value.latitude;
                            var latitude2 = value.latitude;
                            _services.updateUser({
                              'location': GeoPoint(latitude!, latitude2!),
                            }, context).then((value) {
                              Navigator.pushNamed(context, HomeScreen.id);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0.0,
                      leading: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Use current location',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        location == null ? 'Fetching location' : _address,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 4, top: 4),
                        child: Text(
                          'CHOOSE CITY',
                          style: TextStyle(
                              color: Colors.blueGrey.shade900, fontSize: 12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        dropdownDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value!;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value!;
                            manualAddress =
                                '$cityValue, $stateValue, $countryValue';
                          });
                          _services.updateUser({
                            'address': manualAddress,
                            'state': stateValue,
                            'city': cityValue,
                            'country': countryValue
                          }, context).then((value) {
                            Navigator.pushNamed(context, HomeScreen.id);
                          });
                        },
                      ),
                    ),
                  ],
                );
              });
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: 350,
            ),
          ),
          Text(
            'Where do want \n to buy/sell products',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'To enjoy all that we have to offer you \n we need to know where to look for them',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ))
                      : ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          icon: Icon(CupertinoIcons.location_fill),
                          label: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              'Around me',
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _loading = true;
                            });
                            getLocation().then((value) {
                              print(_locationData.latitude);
                              if (value != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              progressDialog.show();
              showBottomScreen(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
                child: Text(
                  'Set location manually',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
