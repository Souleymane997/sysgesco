import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:get/get.dart' as getx;

import 'colors.dart';
import 'custom_text.dart';


class DInfo {
  /* DIALOGUE BOX */

  static Future<bool> dialogConfirmation(
    BuildContext context,
    String title,
    String content, {
    String textNo = 'NON',
    String textYes = 'OUI',
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(textNo),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(textYes),
            ),
          ],
        );
      },
    );
  }

  /// dialog for response error
  /// not automatically closed, so you have to use DInfo.close() after this
  static void dialogError(String message) {
    getx.Get.dialog(
      SimpleDialog(
        children: [
          Center(
            child: Icon(
              Icons.error_outline_outlined,
              color: Colors.red[700],
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void dialogSuccess(String message) {
    getx.Get.dialog(
      SimpleDialog(
        children: [
          Center(
            child: Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green[700],
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// close dialog and callback
  static void closeDialog(
      {Duration? durationBeforeClose, Function? actionAfterClose}) {
    Future.delayed(
      durationBeforeClose ?? const Duration(milliseconds: 2500),
      () {
        getx.Get.back();
        if (actionAfterClose != null) actionAfterClose.call();
      },
    );
  }

  /* TOAST  */

  /// fast response for error with automatically close
  static void toastError(String message, {bool isLong = false}) {
    toast.Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? toast.Toast.LENGTH_LONG : toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[100],
      textColor: Colors.red[900],
      fontSize: 16,
    );
  }

  /// fast response for success with automatically close
  static void toastSuccess(String message, {bool isLong = false}) {
    toast.Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? toast.Toast.LENGTH_LONG : toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[100],
      textColor: Colors.green[900],
      fontSize: 16,
    );
  }

  /// fast response for netral with automatically close
  static void toastNetral(String message, {bool isLong = false}) {
    toast.Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? toast.Toast.LENGTH_LONG : toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue[100],
      textColor: Colors.blue[900],
      fontSize: 16,
    );
  }

/* SNACK BAR */

  /// response below of ui for error with automatically close
  static void snackBarError(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.red.shade400,
         elevation: 10,
        //padding: const EdgeInsets.all(10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.error,
              color: blanc(),
              size: 40,
            ),
            Expanded(child: CustomText(message)),
          ],
        )));
  }

  static void snackBarSuccess(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.teal.shade300,
        elevation: 10,
        //padding: const EdgeInsets.all(10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.check_circle_sharp,
              color: blanc(),
              size: 40,
            ),
            Expanded(child: CustomText(message)),
          ],
        )));
  }
}
