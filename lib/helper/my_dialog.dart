import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/custom_loading.dart';

class MyDialog {
//info
  static void info(String msg) {
    Get.snackbar('Info', msg,
        backgroundColor: Colors.blue.withAlpha(178), colorText: Colors.white);
  }

//success
  static void success(String msg) {
    Get.snackbar('Success', msg,
        backgroundColor: Colors.green.withAlpha(178), colorText: Colors.white);
  }

//error
  static void error(String msg) {
    Get.snackbar('Error', msg,
        backgroundColor: Colors.redAccent.withAlpha(178),
        colorText: Colors.white);
  }

  //loading dialog
  static void showLoadingDialog() {
    Get.dialog(const Center(child: CustomLoading()));
  }
}