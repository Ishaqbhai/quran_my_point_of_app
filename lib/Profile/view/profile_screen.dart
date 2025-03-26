import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/enums/quran_language.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    // List<dynamic> QuranLanguage1 = [
    //   english('English'),
    //   hindi('Hindi'),
    //   malayalam('Malayalam'),
    //   tamil('Tamil'),
    //   urdu('Urdu'),
    // ];

    return Scaffold(
      appBar: AppBar(leading: SizedBox.shrink(), title: Text("Profile")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return DropdownButton<QuranLanguage>(
                value: profileController.selectedLanguage.value,
                items:
                    QuranLanguage.values.map((QuranLanguage language) {
                      return DropdownMenuItem<QuranLanguage>(
                        value: language,
                        child: Text(
                          language.toString().split('.').last.toUpperCase(),
                        ),
                      );
                    }).toList(),
                onChanged: (QuranLanguage? newLanguage) {
                  if (newLanguage != null) {
                    profileController.updateLanguage(newLanguage);
                  }
                },
              );
              // return DropdownButtonFormField<String>(
              //     value: "Ayat",
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       filled: true,
              //       //  fillColor: Colors.white,
              //     ),
              //     items: ["QuranLanguage.english", "QuranLanguage.tamil", "QuranLanguage.urdu", "QuranLanguage.malayalam"]
              //         .map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: profileController.language.value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              // onChanged: (String? newValue) {
              //   profileController.changeLanguage(lang: newValue!);
              //    });
            }),
          ),
        ],
      ),
    );
  }
}
