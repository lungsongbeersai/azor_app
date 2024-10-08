import 'dart:convert';

import 'package:azor/models/cart_models.dart';
import 'package:azor/models/category_models.dart';
import 'package:azor/models/cook_models.dart';
import 'package:azor/models/login_models.dart';
import 'package:azor/models/product_getID_set.dart';
import 'package:azor/models/product_getid_models.dart';
import 'package:azor/models/product_models.dart';
import 'package:azor/models/product_search_page.dart';
import 'package:azor/models/table_models.dart';
import 'package:azor/models/zone_models.dart';
import 'package:http/http.dart' as http;

class APIService {
  String urlAPI = "http://azor.plc.la/api";
  Future<LoginInfo> login(String email, String password) async {
    final http.Response response =
        await http.post(Uri.parse('${urlAPI.toString()}/?api_login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'users_name': email,
              'users_password': password,
            }));
    if (response.statusCode == 200) {
      return LoginInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Login.');
    }
  }

  Future<List<ZoneModel>> zoneApi(String branchID) async {
    List<ZoneModel> zoneList = [];
    final http.Response response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_zone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'zone_branch_fk': branchID,
      }),
    );

    if (response.statusCode == 200) {
      zoneList = (json.decode(response.body) as List)
          .map((e) => ZoneModel.fromJson(e))
          .toList();
      return zoneList;
    } else {
      throw Exception(
          'Failed to fetch exercise, status code: ${response.statusCode}');
    }
  }

  Future<List<TableModel>> tableApi(
      String branchID, String zone, int itemActive) async {
    List<TableModel> tableList = [];
    final http.Response response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_table'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'table_branch_fk': branchID.toString(),
        'table_zone_fk': zone.toString(),
        'active': itemActive.toString()
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is List) {
        tableList = responseData.map((e) => TableModel.fromJson(e)).toList();
      } else if (responseData is Map) {
        if (responseData.containsKey('data') && responseData['data'] is List) {
          tableList = (responseData['data'] as List)
              .map((e) => TableModel.fromJson(e))
              .toList();
        } else {
          throw Exception('emty: $responseData');
        }
      }
      return tableList;
    } else {
      throw Exception(
          'Failed to fetch data, status code: ${response.statusCode}');
    }
  }

  Future<List<CategoryModel>> categoryApi(String itemActive) async {
    List<CategoryModel> categoryList = [];
    final http.Response response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'active': itemActive.toString()}),
    );

    if (response.statusCode == 200) {
      categoryList = (json.decode(response.body) as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return categoryList;
    } else {
      throw Exception(
          'Failed to fetch exercise, status code: ${response.statusCode}');
    }
  }

  Future<List<ProductSearch>> productSearch(String branch, String name) async {
    List<ProductSearch> productSearch = [];
    try {
      final http.Response response = await http.post(
        Uri.parse('${urlAPI.toString()}/?api_product_search'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'branch_code': branch.toString(),
          'product_name': name.toString(),
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          final decodedResponse = json.decode(responseBody);

          if (decodedResponse is List) {
            productSearch =
                decodedResponse.map((e) => ProductSearch.fromJson(e)).toList();
          } else if (decodedResponse is Map &&
              decodedResponse['status'] == 'error') {
          } else {
            throw Exception('Unexpected response format');
          }
        } catch (e) {
          throw Exception('Failed to parse response');
        }
      } else {
        throw Exception(
            'Failed to fetch product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
    return productSearch;
  }

  Future<List<ProductListModel>> productApi(
      String cateid, String branch, String status, String itemActive) async {
    List<ProductListModel> productList = [];
    final http.Response response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_productList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'product_cate_fk': cateid.toString(),
        'branch_code': branch.toString(),
        'status': status.toString(),
        'itemActive': itemActive.toString(),
      }),
    );

    if (response.statusCode == 200) {
      productList = (json.decode(response.body) as List)
          .map((e) => ProductListModel.fromJson(e))
          .toList();
      return productList;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<ProductGetidSet>> productGetIDSet(String proid) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_product_set'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'product_id': proid,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => ProductGetidSet.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<ProductGetid>> productGetID(String proid) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?api_product_getId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'product_id': proid,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => ProductGetid.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  // Future<bool> addCart(
  //     String billtable,
  //     String billbranch,
  //     String orderlistprocodefk,
  //     String orderlistprice,
  //     int orderlistqty,
  //     int orderlistpercented,
  //     String orderliststatuscook,
  //     String orderlistnoteremark,
  //     String orderlistcreateby,
  //     String orderToppingList,
  //     String status) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${urlAPI.toString()}/?insertOrder'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         // Ensure dynamic type here
  //         "bill_table": billtable,
  //         "bill_branch": billbranch,
  //         "order_list_pro_code_fk": orderlistprocodefk,
  //         "order_list_price": orderlistprice,
  //         "order_list_qty": orderlistqty,
  //         "order_list_percented": orderlistpercented,
  //         "order_list_status_cook": orderliststatuscook,
  //         "order_list_note_remark": orderlistnoteremark,
  //         "order_list_create_by": orderlistcreateby,
  //         "orderToppingList": orderToppingList,
  //         "status": status
  //       }),
  //     );

  //     // print("Response status: ${response.statusCode}");
  //     // print("Response body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       // Attempt to decode JSON to confirm it’s valid
  //       try {
  //         final jsonResponse = jsonDecode(response.body);
  //         return true;
  //       } catch (e) {
  //         print("JSON decode error: $e");
  //         return false;
  //       }
  //     } else {
  //       print('Failed to fetch Product, status code: ${response.statusCode}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Request error: $e');
  //     return false;
  //   }
  // }

  Future<bool> addCart(
      String billtable,
      String billbranch,
      String orderlistprocodefk,
      String orderlistprice,
      int orderlistqty,
      int orderlistpercented,
      String orderliststatuscook,
      String orderlistnoteremark,
      String orderlistcreateby,
      String orderToppingList,
      String status) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?insertOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "bill_table": billtable.toString(),
        "bill_branch": billbranch.toString(),
        "order_list_pro_code_fk": orderlistprocodefk.toString(),
        "order_list_price": orderlistprice.toString(),
        "order_list_qty": orderlistqty.toString(),
        "order_list_percented": orderlistpercented.toString(),
        "order_list_status_cook": orderliststatuscook.toString(),
        "order_list_note_remark": orderlistnoteremark.toString(),
        "order_list_create_by": orderlistcreateby.toString(),
        "orderToppingList": orderToppingList.toString(),
        "status": status.toString()
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<CartModels>> cartApi(
      String tableID, String branchID, String status) async {
    List<CartModels> cartList = [];
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?carts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_list_table_fk': tableID,
        'order_list_branch_fk': branchID,
        'order_list_status_order': status.toString()
      }),
    );

    if (response.statusCode == 200) {
      cartList = (json.decode(response.body) as List)
          .map((e) => CartModels.fromJson(e))
          .toList();
      return cartList;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<CartModels>> cartApi2(
      String tableID, String branchID, int status) async {
    List<CartModels> cartList = [];
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?carts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_list_table_fk': tableID,
        'order_list_branch_fk': branchID,
        'order_list_status_order': status.toString()
      }),
    );

    if (response.statusCode == 200) {
      cartList = (json.decode(response.body) as List)
          .map((e) => CartModels.fromJson(e))
          .toList();
      return cartList;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<CartModels>> cartApi3(
      String tableID, String branchID, int status) async {
    List<CartModels> cartList = [];
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?carts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_list_table_fk': tableID,
        'order_list_branch_fk': branchID,
        'order_list_status_order': status.toString()
      }),
    );

    if (response.statusCode == 200) {
      cartList = (json.decode(response.body) as List)
          .map((e) => CartModels.fromJson(e))
          .toList();
      return cartList;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<List<CartModels>> cartApi4(
      String tableID, String branchID, int status) async {
    List<CartModels> cartList = [];
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?carts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_list_table_fk': tableID,
        'order_list_branch_fk': branchID,
        'order_list_status_order': status.toString()
      }),
    );

    if (response.statusCode == 200) {
      cartList = (json.decode(response.body) as List)
          .map((e) => CartModels.fromJson(e))
          .toList();
      return cartList;
    } else {
      throw Exception(
          'Failed to fetch Product, status code: ${response.statusCode}');
    }
  }

  Future<bool> updateCart(
    String orderlistcode,
    int orderlistpercented,
    String option,
    String table,
  ) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?update_cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "order_list_code": orderlistcode.toString(),
        "order_list_percented": orderlistpercented.toString(),
        "option": option.toString(),
        "order_list_table_fk": table.toString()
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update qty: ${response.statusCode}');
    }
  }

  Future<bool> deleteCart(String orderlistcode, String table) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?delete_cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "order_list_code": orderlistcode,
        "table_code": table,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update qty: ${response.statusCode}');
    }
  }

  Future<bool> deleteCartSuccess(String orderlistcode, String table) async {
    final response = await http.post(
      Uri.parse('${urlAPI.toString()}/?delete_cart_success'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "order_list_code": orderlistcode,
        "order_list_table_fk": table,
      }),
    );

    if (response.statusCode == 200) {
      print("result: ${response.statusCode}");
      return true;
    } else {
      throw Exception('Failed to update qty: ${response.statusCode}');
    }
  }

  Future<bool> confirmOrder(List<String> orderListCode, status) async {
    final url = Uri.parse('http://api-azor.plc.la/update_cart');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'order_list_code': orderListCode,
          'status': status,
        }),
      );
      if (response.statusCode == 200) {
        return true; // Indicate success
      } else {
        return false; // Indicate failure
      }
    } catch (error) {
      return false; // Indicate failure
    }
  }

  Future<List<CooksModel>> cookPageApi(
    String branchID,
    String cookstatus,
    int orderstatus,
    String cookingfrom,
  ) async {
    List<CooksModel> cookList = [];
    final response = await http.post(
      Uri.parse('http://api-azor.plc.la/order_cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_list_branch_fk': branchID,
        'order_list_status_cook': cookstatus,
        'order_list_status_order': orderstatus.toString(),
        'pro_detail_cooking_status': cookingfrom,
      }),
    );

    if (response.statusCode == 200) {
      cookList = (json.decode(response.body) as List)
          .map((e) => CooksModel.fromJson(e))
          .toList();
      return cookList;
    } else {
      throw Exception(
          'Failed to fetch Cook cart, status code: ${response.statusCode}');
    }
  }

  Future<bool> apiConfirmCooking(int orderStatus, String listCode) async {
    final response = await http.post(
      Uri.parse('http://api-azor.plc.la/order_status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "order_list_status_order": orderStatus.toString(),
        "order_list_code": listCode
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update order status: ${response.statusCode}');
    }
  }
}
