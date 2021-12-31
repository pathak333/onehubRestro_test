import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DialogHelper {

  static void showLoader(){
    Get.dialog(
      Dialog(
        child: Container(
          padding: EdgeInsets.all(15),
          width:80,
          height: 80,
          child: Lottie.asset('lib/assets/icons/animated/loader.json'),
        ),
        shape: CircleBorder(),
      ),
      barrierDismissible: false
    );
  }

  static void hideLoader() {
    if(Get.isDialogOpen) Get.back();
  }
}