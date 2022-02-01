import 'package:flutter/material.dart';
import 'package:flutter_task/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMsg(var msg) {
  Fluttertoast.showToast(
      msg: msg != null ? msg : "Somthing went Wrong",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}

void onLoading({required BuildContext context, String? value}) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
              child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: new Row(
              children: [
                new CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                SizedBox(
                  width: 20,
                ),
                new Text(
                  value ?? "Loading . . .",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
        );
      });
}
