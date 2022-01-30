import 'package:flutter/material.dart';
import 'package:flutter_task/utils/colors.dart';

void onLoading({required BuildContext context,String? value}) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
                child: Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              child: new Row(
                children: [
                  new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  new Text(
                    value??"Loading . . .",
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
