import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran.dart';
import 'package:quran_hadith_app/core/app_routes.dart';
import 'package:quran_hadith_app/core/theme.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoadingController());
  await Quran.initialize();

  await Supabase.initialize(
    url: 'https://cmbwbnfqjkqyryrpaify.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNtYndibmZxamtxeXJ5cnBhaWZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5MDc1NTMsImV4cCI6MjA2MDQ4MzU1M30.zVkEIu2_7g7zm03tfqLZ-L-sxe7X9ZiQ2317EUOj4AQ',
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    );
  }
}
