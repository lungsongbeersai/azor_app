import 'package:azor/models/category_models.dart';
import 'package:azor/models/login_models.dart';
import 'package:azor/models/product_getID_models.dart';
import 'package:azor/models/product_models.dart';
import 'package:azor/models/table_models.dart';
import 'package:azor/models/zone_models.dart';
import 'package:azor/services/api_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderService extends ChangeNotifier {
  List<ZoneModel> zoneList = [];
  List<TableModel> tableList = [];
  List<CategoryModel> categoryList = [];
  List<ProductListModel> productList = [];
  List<ProductGetId> productID = [];

  int _quantity = 1;
  String _selectedSize = '';

  int get quantity => _quantity;
  String get selectedSize => _selectedSize;

  int selectedIndex = 0;
  int _pageselectedIndex = 1;
  int get pageselected => _pageselectedIndex;

  String massageMsg = "";

  final PageController _pageController = PageController(initialPage: 1);
  PageController get pageController => _pageController;

  set pageselected(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 5), curve: Curves.ease);
    _pageselectedIndex = index;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    LoginInfo resp =
        await APIService().login(email.toString(), password.toString());
    if (resp.status == "success") {
      _sharedPreferance("users_id", resp.usersId.toString());
      _sharedPreferance("users_name", resp.usersName.toString());
      _sharedPreferance("branch_code", resp.branchCode.toString());
      _sharedPreferance("branch_name", resp.branchName.toString());
      _sharedPreferance("status_code", resp.statusCode.toString());
      _sharedPreferance("status_name", resp.statusName.toString());

      MyData.usersID = resp.usersId.toString();
      MyData.usersName = resp.usersName.toString();
      MyData.branchCode = resp.branchCode.toString();
      MyData.branchName = resp.branchName.toString();
      MyData.statusCode = resp.statusCode.toString();
      MyData.statusName = resp.statusName.toString();

      return true;
    } else {
      massageMsg = resp.message.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> _sharedPreferance(String key, String value) async {
    try {
      final resp = await SharedPreferences.getInstance();
      await resp.setString(key, value);
    } catch (e) {
      print("Error wSharedPreferences: $e");
    }
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void updateSelectedSize(String newSize) {
    _selectedSize = newSize;
    notifyListeners();
  }

  getZone() async {
    try {
      zoneList = await APIService().zoneApi(MyData.branchCode);
      notifyListeners();
    } catch (e) {
      print('Error fetching zones: $e');
    }
  }

  getTable() async {
    try {
      tableList = await APIService().tableApi(MyData.branchCode, '', 0);
      notifyListeners();
    } catch (e) {
      print('Error fetching table: $e');
    }
  }

  getTableGetId(String brachID, String zoneID, int itemActive) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      selectedIndex = itemActive;
      tableList =
          await APIService().tableApi(MyData.branchCode, zoneID, itemActive);
      notifyListeners();
      EasyLoading.dismiss();
    } catch (e) {
      print('Error get ID zone: $e');
    }
  }

  getCategory(int itemActive) async {
    selectedIndex = itemActive;
    try {
      categoryList = await APIService().categoryApi(
        itemActive.toString(),
      );
      notifyListeners();
    } catch (e) {
      EasyLoading.dismiss();
      print('Error fetching Category: $e');
    }
  }

  getProduct(String cateid, String status, int itemActive) async {
    selectedIndex = itemActive;
    try {
      productList = await APIService().productApi(
        cateid.toString(),
        status.toString(),
        itemActive.toString(),
      );
      EasyLoading.dismiss();
      notifyListeners();
    } catch (e) {
      EasyLoading.dismiss();
      print('Error fetching get Product: $e');
    }
  }

  Future<List<ProductGetId>> getProductID(String proid) async {
    try {
      final List<ProductGetId> products =
          await APIService().productGetID(proid);
      return products;
    } catch (e) {
      throw Exception('Failed to load product details: $e');
    }
  }

  // Future<ProductGetId> getProductID(String proid) async {
  //   try {
  //     final List<ProductGetId> products =
  //         await APIService().productGetID(proid);
  //     if (products.isNotEmpty) {
  //       return products.first;
  //     } else {
  //       throw Exception('No product found');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load product details: $e');
  //   }
  // }

  getPullRefresh() {
    getZone();
    selectedIndex = 0;
    getTable();
    getCategory(selectedIndex);
    getProduct("", "", 1);
  }
}
