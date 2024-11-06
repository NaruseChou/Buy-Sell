import 'package:buy_sell/screens/services/phoneauth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone-auth-screen';

  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool validate = false;

  var countryCodeController = TextEditingController(text: '+7');
  var phoneNumberController = TextEditingController();

  final PhoneAuthService _service = PhoneAuthService();

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Please wait',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red.shade400,
              child: const Icon(
                CupertinoIcons.person_crop_circle,
                color: Colors.black,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Enter your Phone',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'We will send confirmation code to your phone',
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: countryCodeController,
                    enabled: false,
                    decoration: const InputDecoration(
                        counterText: '  ', labelText: 'Country'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validate = true;
                        });
                      }
                      if (value.length < 10) {
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    autofocus: true,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Number',
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: validate
                    ? WidgetStateProperty.all(Theme.of(context).primaryColor)
                    : WidgetStateProperty.all(Colors.grey),
              ),
              onPressed: () {
                progressDialog.show();
                String number =
                    '${countryCodeController.text}${phoneNumberController.text}';

                _service.verifyPhoneNumber(context, number);
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
