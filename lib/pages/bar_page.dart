import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BarPage extends StatefulWidget {
  const BarPage({super.key});

  @override
  State<BarPage> createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  IO.Socket? socket;
  String? barOrderConfirmation;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://api-azor.plc.la:8091', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();

    socket?.onConnect((_) {
      print('connected to BarPage');
    });

    socket?.on('orderBar', (data) {
      print('Received Bar order: ${data['message']}');
      setState(() {
        barOrderConfirmation = data['message'];
      });
      _showOrderConfirmationDialog('Bar Order', data['message']);
    });

    socket?.onDisconnect((_) {
      print('disconnected from BarPage');
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
        title: const Text('Bar Page'),
      ),
      body: Center(
        child: barOrderConfirmation != null
            ? Text('Bar Order: $barOrderConfirmation')
            : const Text('No new Bar orders'),
      ),
    );
  }
}
