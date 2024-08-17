import 'package:azor/models/cart_models.dart';
import 'package:azor/models/category_models.dart';
import 'package:azor/models/cook_models.dart';
import 'package:azor/models/login_models.dart';
import 'package:azor/models/product_getid_models.dart';
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
  List<ProductGetid> productID = [];
  List<CartModels> cartList = [];
  List<CartModels> cartList2 = [];
  List<CartModels> cartList3 = [];
  List<CooksModel> cookList = [];

  int cartNetTotal = 0;
  int cartQty = 0;
  int cartNetTotal2 = 0;
  int cartQty2 = 0;
  int cartNetTotal3 = 0;
  int cartQty3 = 0;
  int itemCount = 0;
  int _quantity = 1;
  String _selectedSize = '';

  int get quantity => _quantity;
  String get selectedSize => _selectedSize;

  String massageMsg = "";

  int selectedIndex = 0;
  int _pageselectedIndex = 1;
  int get pageselected => _pageselectedIndex;

  int _pageselectedIndex1 = 0;
  int get pageselected1 => _pageselectedIndex1;

  int _pageSelectedIndex = 0;
  int get pageSelected => _pageSelectedIndex;

  final PageController _pageController = PageController(initialPage: 1);
  PageController get pageController => _pageController;

  set pageselected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 5),
      curve: Curves.ease,
    );
    _pageselectedIndex = index;
    notifyListeners();
  }

  final PageController _pageController1 = PageController(initialPage: 0);
  PageController get pageController1 => _pageController1;

  set pageselected1(int index) {
    _pageController1.animateToPage(
      index,
      duration: const Duration(milliseconds: 5),
      curve: Curves.ease,
    );
    _pageselectedIndex1 = index;
    notifyListeners();
  }

  final PageController _pagecontroller = PageController(initialPage: 0);
  PageController get pagecontroller => _pagecontroller;

  set pageSelected(int index) {
    _pageSelectedIndex = index;
    _pagecontroller.animateToPage(
      index,
      duration: const Duration(milliseconds: 5),
      curve: Curves.bounceIn,
    );
    notifyListeners();
  }

  void resetPage() {
    _pageSelectedIndex = 0;
    pagecontroller.jumpToPage(0);
    notifyListeners();
  }

  ProviderService() {
    getZone();
    getTable();
    getCookPageApi(2);
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
      _sharedPreferance("cook_status_name", resp.cookingStatus.toString());
      _sharedPreferance("cook_status_name", resp.cookStatusName.toString());
      _sharedPreferance("off_on", resp.offOn.toString());

      MyData.usersID = resp.usersId.toString();
      MyData.usersName = resp.usersName.toString();
      MyData.branchCode = resp.branchCode.toString();
      MyData.branchName = resp.branchName.toString();
      MyData.statusCode = resp.statusCode.toString();
      MyData.statusName = resp.statusName.toString();
      MyData.cookStatus = resp.cookingStatus.toString();
      MyData.cookName = resp.cookStatusName.toString();
      MyData.offOn = resp.offOn.toString();
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

  Future<void> logout() async {
    clearSharedPreferences();
    notifyListeners();
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  void updateSelectedSize(String newSize) {
    _selectedSize = newSize;
    notifyListeners();
  }

  void resetSelectedSize() {
    _selectedSize = '';
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
    await Future.delayed(const Duration(seconds: 2));
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

  Future<List<ProductGetid>> getProductID(String proid) async {
    try {
      final List<ProductGetid> products =
          await APIService().productGetID(proid);
      return products;
    } catch (e) {
      throw Exception('Failed to load product details: $e');
    }
  }

  Future<bool> addCart(
      String billtable,
      String branchCode,
      String orderlistprocodefk,
      String orderlistprice,
      int orderlistqty,
      int orderlistpercented,
      String statuscook,
      String remark,
      String userID) async {
    final isSuccess = await APIService().addCart(
        billtable,
        branchCode,
        orderlistprocodefk,
        orderlistprice,
        orderlistqty,
        orderlistpercented,
        statuscook,
        remark,
        userID);
    if (isSuccess == true) {
      EasyLoading.dismiss();
      resetQuantity();
      getTable();
      getCartList(billtable, '1');
      notifyListeners();
      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  getCart(String tableID, String status) async {
    try {
      cartList = await APIService().cartApi(tableID, MyData.branchCode, status);
      notifyListeners();
    } catch (e) {
      print('Error fetching Cart: $e');
    }
  }

  getCart2(String tableID) async {
    try {
      cartList2 = await APIService().cartApi2(tableID, MyData.branchCode, 2);
      notifyListeners();
    } catch (e) {
      print('Error fetching Cart: $e');
    }
  }

  getCart3(String tableID) async {
    try {
      cartList3 = await APIService().cartApi3(tableID, MyData.branchCode, 3);
      notifyListeners();
    } catch (e) {
      print('Error fetching Cart: $e');
    }
  }

  getCartList(String tableID, String status) async {
    cartList = await APIService().cartApi(
      tableID,
      MyData.branchCode,
      status,
    );
    cartNetTotal = 0;
    cartQty = 0;
    itemCount = 0;
    for (int i = 0; i < cartList.length; i++) {
      final item = cartList[i];
      cartQty += int.parse(item.orderListQty.toString());
      cartNetTotal += int.parse(item.orderListTotal.toString());
      itemCount += 1;
    }
    notifyListeners();
  }

  getCartList2(String tableID) async {
    cartList2 = await APIService().cartApi2(
      tableID,
      MyData.branchCode,
      2,
    );
    cartNetTotal2 = 0;
    cartQty2 = 0;
    for (int i = 0; i < cartList2.length; i++) {
      final item = cartList2[i];
      cartQty2 += int.parse(item.orderListQty.toString());
      cartNetTotal2 += int.parse(item.orderListTotal.toString());
    }
    notifyListeners();
  }

  getCartList3(String tableID) async {
    cartList3 = await APIService().cartApi3(
      tableID,
      MyData.branchCode,
      3,
    );
    cartNetTotal3 = 0;
    cartQty3 = 0;
    for (int i = 0; i < cartList3.length; i++) {
      final item = cartList3[i];
      cartQty3 += int.parse(item.orderListQty.toString());
      cartNetTotal3 += int.parse(item.orderListTotal.toString());
    }
    notifyListeners();
  }

  Future<bool> getupdateCart(String orderlistcode, int orderlistpercented,
      String option, String table, String status) async {
    final isSuccess = await APIService()
        .updateCart(orderlistcode, orderlistpercented, option, table);
    if (isSuccess == true) {
      EasyLoading.dismiss();
      getCartList(table.toString(), status.toString());
      resetQuantity();
      notifyListeners();
      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getDeleteCart(
      String orderlistcode, String table, String status) async {
    final isSuccess = await APIService()
        .deleteCart(orderlistcode.toString(), table.toString());
    if (isSuccess == true) {
      EasyLoading.dismiss();
      resetQuantity();
      getCartList(table, status);
      getCartList2(table);
      getTable();
      notifyListeners();
      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getDeleteSccessCart(
      String orderlistcode, String table, String status) async {
    final isSuccess = await APIService()
        .deleteCartSuccess(orderlistcode.toString(), table.toString());
    if (isSuccess == true) {
      EasyLoading.dismiss();
      resetQuantity();
      getCartList(table, status);
      getCartList2(table);
      getTable();
      notifyListeners();
      return true;
    } else {
      print("result: error");
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getConfirm(List<String> orderListCodes, status) async {
    EasyLoading.show(status: 'ກໍາລັງໂຫຼດ...');

    final isSuccess = await APIService().confirmOrder(orderListCodes, status);

    if (isSuccess) {
      notifyListeners();
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  getCookPageApi(int orderStatus) async {
    try {
      cookList = await APIService().cookPageApi(
        MyData.branchCode,
        MyData.offOn,
        orderStatus,
        MyData.cookStatus,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load Order Cart: $e');
    }
  }

  getPullRefresh() {
    getZone();
    getTable();
    getCategory(0);
    getProduct("", "", 1);
    getCookPageApi(2);
    notifyListeners();
  }
}
