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
        currentIndex:
            Provider.of<ProviderService>(context, listen: false).pageSelected,
        onTap: (value) {
          Provider.of<ProviderService>(context, listen: false).pageSelected =
              value;
        },
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Handle tap action for page 0
                Provider.of<ProviderService>(context, listen: false)
                    .pageSelected = 0;
                Provider.of<ProviderService>(context, listen: false)
                    .pagecontroller
                    .jumpToPage(0);
              },
              child: const Icon(Icons.filter_1),
            ),
            label: 'ກໍາລັງສັ່ງ',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Handle tap action for page 1
                Provider.of<ProviderService>(context, listen: false)
                    .pageSelected = 1;
                Provider.of<ProviderService>(context, listen: false)
                    .pagecontroller
                    .jumpToPage(1);
              },
              child: const Icon(Icons.filter_2),
            ),
            label: 'ຢືນຢັນອໍເດີ',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Handle tap action for page 2
                Provider.of<ProviderService>(context, listen: false)
                    .pageSelected = 2;
                Provider.of<ProviderService>(context, listen: false)
                    .pagecontroller
                    .jumpToPage(2);
              },
              child: const Icon(Icons.filter_3),
            ),
            label: 'ສໍາເລັດແລ້ວ',
          ),
        ],
      ),
    );
  }
}
