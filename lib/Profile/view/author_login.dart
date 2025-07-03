import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';

class AuthorLogin extends StatelessWidget {
  AuthorLogin({super.key});
  final TextEditingController nameController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Author Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              profileController.logout();
              Get.snackbar("Success", "✅ Author logout successfully.");
              homeController.changeBottomNavIndex(index: 0);
              Get.off(HomeScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors().appBarColor,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Enter your UserName",
                    style: TextStyle(color: AppColors().appTextColor),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "UserName",
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter your Password",
                    style: TextStyle(color: AppColors().appTextColor),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim() == "Author" &&
                            passwordController.text.trim() == "QuranApp") {
                          Get.snackbar(
                            "Success",
                            "✅ Author login successfully.",
                          );

                          profileController.login(
                            userName: nameController.text,
                            password: passwordController.text,
                          );
                          homeController.changeBottomNavIndex(index: 0);
                          Get.off(HomeScreen());
                        } else {
                          Get.snackbar("Error", "✅ Author login Failed.");
                        }
                      },
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
