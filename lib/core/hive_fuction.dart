import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<Map<String, Map<String, Map<String, dynamic>>>>
getHadithDataFromHive() async {
  await Hive.initFlutter(); // Ensure Hive is initialized
  var box = await Hive.openBox<String>('hadithBox'); // Open the box

  String? jsonString = box.get('hadithData');

  if (jsonString != null) {
    return jsonDecode(
      jsonString,
    ).cast<String, Map<String, Map<String, dynamic>>>();
  } else {
    return {};
  }
}

Future<void> printHadithData() async {
  await Hive.initFlutter(); // Ensure Hive is initialized
  var box = await Hive.openBox<String>('hadithBox'); // Open the box

  String? jsonString = box.get('hadithData');

  if (jsonString == null) {
    Get.snackbar("No Data", "📦 No Hadith data found in Hive.");
    return;
  }

  // Decode JSON string
  Map<String, dynamic> decodedData = jsonDecode(jsonString);

  // Define the expected data structure
  Map<String, Map<String, Map<String, dynamic>>> hadithData = {};

  // Convert the nested JSON structure manually
  for (String bookKey in decodedData.keys) {
    var bookValue = decodedData[bookKey] as Map<String, dynamic>;
    hadithData[bookKey] = {};

    for (String chapterKey in bookValue.keys) {
      var chapterValue = bookValue[chapterKey] as Map<String, dynamic>;
      hadithData[bookKey]![chapterKey] = {};

      for (String dataKey in chapterValue.keys) {
        hadithData[bookKey]![chapterKey]![dataKey] = chapterValue[dataKey];
      }
    }
  }
}
