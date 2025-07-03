import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;


  void showLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });
  }

  void hideLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
}
