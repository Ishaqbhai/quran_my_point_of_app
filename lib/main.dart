import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran.dart';
import 'package:quran_hadith_app/boarding/view/global_loader.dart';
import 'package:quran_hadith_app/core/app_routes.dart';
import 'package:quran_hadith_app/core/theme.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoadingController());
  await Quran.initialize();
  // if (Hive.isBoxOpen('hadithBox')) {
  //   await Hive.box('hadithBox').close(); // Close the box before deleting
  //   await Hive.deleteBoxFromDisk('hadithBox');
  //  }

  // ✅ Open it as a Box<Map>
  // await Hive.openBox<Map>('hadithBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: lightTheme,
      initialRoute: '/splash_screen',
      getPages: AppRoutes.routes, // Use the routes from AppRoutes
      // builder: (context, child) {
      //   return Stack(
      //     children: [
      //       child!, // Main app UI
      //       GlobalLoader(), // The global loading overlay
      //     ],
      //   );
      // },
    );
    // initialRoute: '/home_screen',
    //   routes: {
    // //    '/quran_screen': (context) => QuranScreen(),
    //     // '/surah_List_screen': (context) => SurahListScreen(),
    //    // '/surah_screen': (context) => SurahScreen(),
    //     '/home_screen': (context) => HomeScreen(),
    //   });
  }
}
