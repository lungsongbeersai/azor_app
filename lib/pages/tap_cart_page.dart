import 'package:azor/pages/cart_page1.dart';
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
        controller:
            Provider.of<ProviderService>(context, listen: true).pageController,
        children: const [
          CartPage1(),
          CartPage1(),
          CartPage1(),
        ],
        onPageChanged: (value) {
          print(
              "result: ${Provider.of<ProviderService>(context, listen: false).selectedIndex}");
          Provider.of<ProviderService>(context, listen: false).selectedIndex =
              value;
          Provider.of<ProviderService>(context, listen: false).getPullRefresh();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        selectedFontSize: 13,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        currentIndex:
            Provider.of<ProviderService>(context, listen: false).selectedIndex,
        onTap: (value) {
          Provider.of<ProviderService>(context, listen: false).selectedIndex =
              value;
          Provider.of<ProviderService>(context, listen: false).getPullRefresh();
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
        selectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
