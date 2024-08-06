import 'package:flutter/material.dart';

class CartPage3 extends StatefulWidget {
  const CartPage3({super.key});

  @override
  State<CartPage3> createState() => _CartPage3State();
}

class _CartPage3State extends State<CartPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.blue,
      title: const Text(
        "ກະຕ໋າຂອງຂ້ອຍ3",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
