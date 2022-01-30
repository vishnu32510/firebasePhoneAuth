import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/screens.dart';
import 'package:flutter_task/services/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future addLoginDetails({required BuildContext context}) async {
  Position position = await determinePosition();
  final ipv4 = await Ipify.ipv4();
  print(ipv4);
  List<Placemark> placemarks =
  await placemarkFromCoordinates(position.latitude, position.longitude);
  print("${placemarks.length} : ${placemarks.first}");
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("login_details")
      .doc()
      .set({
    "date_time": DateTime.now(),
    "ip": "$ipv4",
    "location": placemarks.first.locality,
    "qrImage": ""
  }).then((value) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("login_details").orderBy("date_time",descending: true)
        .get()
        .then((value) {
      print(value.docs.first.id);
      print("trueee");
      Navigator.of(context).pushNamedAndRemoveUntil(
          PluginScreen.routeName, (Route<dynamic> route) => false,
          arguments: PluginScreen(
              userId: FirebaseAuth.instance.currentUser!.uid,
              // loginId : "iRpUgxjgmKffpW8KdVmG"
              loginId : value.docs.first.id
          ));
    });
    return true;
  }).onError((error, stackTrace) {
    print("Error Firestore : $error");
    return false;
  });
}