import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/utilities/colors.dart';

class AppSnackBar {
  static showErrorSnackBar({String message, double width}) {
    Get.snackbar('Error', message,
        maxWidth: width,
        borderRadius: 0,
        backgroundColor: errorRed,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white);
  }

  static showSuccessSnackBar({String message, double width}) {
    Get.snackbar('Success', message,
        maxWidth: width,
        borderRadius: 0,
        backgroundColor: green,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white);
  }
}
