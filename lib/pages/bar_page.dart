import 'package:flutter/material.dart';

class BarPage extends StatefulWidget {
  const BarPage({super.key});

  @override
  State<BarPage> createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "ບານໍ້າ",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
