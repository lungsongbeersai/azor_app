import 'dart:convert';

import 'package:azor/models/login_models.dart';
import 'package:http/http.dart' as http;

class APIService {
  String urlAPI = "http://api.plc.la/api/";
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
}
