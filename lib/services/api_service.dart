import 'dart:convert';

import 'package:azor/models/login_models.dart';
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
}
