import 'package:flutter/material.dart';

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "ຄົວ",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
