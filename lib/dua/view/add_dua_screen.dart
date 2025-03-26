import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDuaScreen extends StatelessWidget {
  const AddDuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Dua")),
      body: Obx(() {
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Dua in Arabic",
                // hintStyle: GoogleFonts.poppins(),
                prefixIcon: Icon(Icons.menu_book_outlined, color: Colors.grey),
                //  border: InputBorder.none,
                //contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        );
      }),
    );
  }
}
