import 'package:flutter/material.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: SizedBox.shrink(), title: Text("Dua")),
      body: Column(children: []),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("+ add Dua"),
      ),
    );
  }
}
