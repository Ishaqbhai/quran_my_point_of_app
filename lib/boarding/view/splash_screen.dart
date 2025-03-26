import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: AssetImage("assests/quran_logo.png"))),
    );
  }

  
}
