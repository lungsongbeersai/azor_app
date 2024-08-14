import 'package:azor/pages/cook_page.dart';
import 'package:azor/pages/cooking_page.dart';
import 'package:azor/pages/cooking_success_page.dart';
import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class TapCookBarPage extends StatefulWidget {
  const TapCookBarPage({Key? key}) : super(key: key);

  @override
  State<TapCookBarPage> createState() => _TapCookBarPageState();
}

class _TapCookBarPageState extends State<TapCookBarPage> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context, listen: true);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: providerService.pageController1,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CookPage(),
                CookingPage(),
                CookingSccessPage(),
              ],
              onPageChanged: (value) {
                providerService.pageselected1 = value;
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ConvexAppBar(
                style: TabStyle.reactCircle,
                backgroundColor: Colors.white,
                activeColor: Colors.blue,
                color: Colors.black54,
                initialActiveIndex: providerService.pageselected1,
                height: 55,
                curveSize: 80,
                top: -30,
                items: const [
                  TabItem(icon: Icons.looks_one, title: 'ອໍເດີໃຫມ່'),
                  TabItem(icon: Icons.looks_two, title: 'ກໍາລັງເຮັດ'),
                  TabItem(icon: Icons.looks_3, title: 'ສໍາເລັດແລ້ວ'),
                ],
                onTap: (int i) {
                  providerService.pageselected1 = i;
                  providerService.pageController1.jumpToPage(i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      _lastPressedAt = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'ກົດກັບຄືນອີກຄັ້ງເພື່ອປິດແອັບ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }
}
