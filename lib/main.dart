import 'package:azor/pages/bar_page.dart';
import 'package:azor/pages/cook_page.dart';
import 'package:azor/pages/login_page.dart';
import 'package:azor/pages/product_detail_page.dart';
import 'package:azor/pages/product_page.dart';
import 'package:azor/pages/search_page.dart';
import 'package:azor/pages/shoping_cart.dart';
import 'package:azor/pages/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:azor/services/provider_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: "BoonBaan",
        ),
        builder: EasyLoading.init(),
        initialRoute: 'login',
        routes: {
          "login": (_) => const LoginPage(),
          "cook": (_) => const CookPage(),
          "bar": (_) => const BarPage(),
          "tap": (_) => const TapPage(),
          "table_id": (_) => const ProductList(),
          "search": (_) => const SearchPage(),
          "product_detail": (_) => const ProductDetail(),
          "shopping_cart": (_) => const ShoppingCartPage(),
        },
      ),
    );
  }
}
