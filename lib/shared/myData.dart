import 'package:intl/intl.dart';

class MyData {
  static String usersID = '';
  static String usersName = '';
  static String branchCode = '';
  static String branchName = '';
  static String statusCode = '';
  static String statusName = '';

  static String formatnumber(dynamic numbers) {
    final formatter = NumberFormat('#,###');
    return formatter.format(numbers);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int? parseInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      print('Error parsing int: $e');
      return null;
    }
  }
}
