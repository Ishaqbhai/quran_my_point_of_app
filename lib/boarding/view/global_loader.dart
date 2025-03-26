import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
// Import your LoadingController

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loadingController = Get.find<LoadingController>();
      return loadingController.isLoading.value
          ? Container(
            color: const Color.fromARGB(255, 41, 40, 40),
            child: Center(child: CircularProgressIndicator()),
          )
          : SizedBox.shrink();
    });
  }
}
