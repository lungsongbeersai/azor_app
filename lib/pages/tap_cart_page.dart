import 'package:azor/pages/cart_page1.dart';
import 'package:azor/pages/cart_page2.dart';
import 'package:azor/pages/cart_page3..dart';
import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class TapCartPage extends StatefulWidget {
  const TapCartPage({super.key});

  @override
  State<TapCartPage> createState() => _TapCartPageState();
}

class _TapCartPageState extends State<TapCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller:
            Provider.of<ProviderService>(context, listen: true).pagecontroller,
        children: const [
          CartPage1(),
          CartPage2(),
          CartPage3(),
        ],
        onPageChanged: (int page) {
          Provider.of<ProviderService>(context, listen: false).pageSelected =
              page;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        currentIndex:
            Provider.of<ProviderService>(context, listen: false).pageSelected,
        onTap: (value) async {
          Provider.of<ProviderService>(context, listen: false).pageSelected =
              value;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_1),
            label: 'ກໍາລັງສັ່ງ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_2),
            label: 'ຢືນຢັນອໍເດີ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_3),
            label: 'ສໍາເລັດແລ້ວ',
          ),
        ],
      ),
    );
  }
}
