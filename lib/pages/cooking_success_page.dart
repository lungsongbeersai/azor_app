import 'package:flutter/material.dart';

class CookingSccessPage extends StatefulWidget {
  const CookingSccessPage({super.key});

  @override
  State<CookingSccessPage> createState() => _CookingSccessPageState();
}

class _CookingSccessPageState extends State<CookingSccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CookingSccess"),
      ),
    );
  }
}
