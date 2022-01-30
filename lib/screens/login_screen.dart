import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/screens.dart';
import 'package:flutter_task/services/services.dart';
import 'package:flutter_task/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => LoginScreen());
  }

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    currentUser();
    print("////////////////////////");
  }

  Future currentUser() async {
    if (FirebaseAuth.instance.currentUser != null && !isLoading) {
      isLoading = true;
      await addLoginDetails(context: context);
      return true;
    } else {
      print("No current user");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: currentUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: primaryColor,
                ),
                Positioned(
                    top: -40,
                    right: -10,
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                Positioned.fill(
                  top: 90,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                  ),
                ),
                Positioned(
                  top: 80,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Positioned.fill(
                    top: 100,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                "Phone Number",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: TextField(
                                autofocus: false,
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  filled: true,
                                  fillColor: primaryColor,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 6.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: secondaryColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                "OTP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: TextField(
                                controller: otpController,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  filled: true,
                                  fillColor: primaryColor,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 6.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: secondaryColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamedAndRemoveUntil(
                                //   PluginScreen.routeName,
                                //   (Route<dynamic> route) => false,
                                // );
                                loginWithPhoneNumber(
                                    context: context,
                                    value: phoneNumberController.text.trim());
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 40),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            );
          }),
    );
  }

  Future loginWithPhoneNumber(
      {required BuildContext context, required String value}) async {
    print("////////");
    print(value);
    onLoading(context: context, value: "Sending OTP");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$value',
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        otpController.text = credential.smsCode ?? "";
        onLoading(context: context, value: "Sighing In");
        print("Verification complete ${credential.smsCode}");
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          var res = await addLoginDetails(context: context);
          print(value.user!.phoneNumber);
        }).onError((error, stackTrace) {
          print(error);
        });
        print("Verification complete ${credential.smsCode}");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Error:: $e");
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        onLoading(context: context, value: "OTP Sent");
        print("verification CS code: " + verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onLoading(context: context, value: "OTP Auto Retrieval Failed");
        print("verification AR code: " + verificationId);
      },
    );
  }
}
