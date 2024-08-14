import 'package:azor/pages/cart_page1.dart';
import 'package:azor/pages/cart_page2.dart';
import 'package:azor/pages/cart_page3..dart';
import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapCartPage extends StatefulWidget {
  const TapCartPage({super.key});

  @override
  State<TapCartPage> createState() => _TapCartPageState();
}

class _TapCartPageState extends State<TapCartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // รีเซ็ตหน้าให้เริ่มต้นที่ Tap 0
      Provider.of<ProviderService>(context, listen: false).resetPage();
    });
  }

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
            Provider.of<ProviderService>(context, listen: true).pageSelected,
        onTap: (value) {
          Provider.of<ProviderService>(context, listen: false).pageSelected =
              value;
          Provider.of<ProviderService>(context, listen: false)
              .pagecontroller
              .jumpToPage(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one_outlined),
            label: 'ກໍາລັງສັ່ງ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two_outlined),
            label: 'ຢືນຢັນອໍເດີ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3_outlined),
            label: 'ສໍາເລັດແລ້ວ',
          ),
        ],
      ),
    );
  }
}
