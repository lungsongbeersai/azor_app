import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  IO.Socket? socket;
  String? cookOrderConfirmation;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://api-azor.plc.la:8091', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();

    socket?.onConnect((_) {
      print('connected to CookPage');
    });

    socket?.on('orderCook', (data) {
      print('Received Cook order event : $data');
      setState(() {
        cookOrderConfirmation = data['message'];
      });
      _showOrderConfirmationDialog('Cook Order', data['message']);
    });

    socket?.onDisconnect((_) {
      print('disconnected from CookPage');
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  void _showOrderConfirmationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ຫ້ອງຄົວ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: cookOrderConfirmation != null
            ? Text('Cook Order: $cookOrderConfirmation')
            : const Text('No new Cook orders'),
      ),
    );
  }
}
