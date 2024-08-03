import 'package:azor/pages/home_page.dart';
import 'package:azor/pages/notifications_page.dart';
import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class TapPage extends StatefulWidget {
  const TapPage({Key? key}) : super(key: key);

  @override
  State<TapPage> createState() => _TapPageState();
}

class _TapPageState extends State<TapPage> {
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
              controller: providerService.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                NotificationPage(),
                HomePage(),
                NotificationPage(),
              ],
              onPageChanged: (value) {
                providerService.pageselected = value;
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
                initialActiveIndex: providerService.pageselected,
                height: 55,
                curveSize: 80,
                top: -30,
                items: const [
                  TabItem(icon: Icons.notifications, title: 'ແຈ້ງເຕືອນ'),
                  TabItem(icon: Icons.home_filled, title: 'ໜ້າຫຼັກ'),
                  TabItem(icon: Icons.shopping_cart, title: 'ກະຕ໋າ'),
                ],
                onTap: (int i) {
                  providerService.pageselected = i;
                  providerService.pageController.jumpToPage(i);
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
