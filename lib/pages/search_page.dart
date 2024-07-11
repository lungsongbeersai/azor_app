import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(right: 5.0), // เพิ่ม margin ด้านขวา
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ຄົ້ນຫາ...',
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Colors.black54),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        // backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('ລາຍການຄົ້ນຫາ...'),
      ),
    );
  }
}
