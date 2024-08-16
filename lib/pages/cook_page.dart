import 'package:audioplayers/audioplayers.dart'; // Import this
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  IO.Socket? socket;
  String? cookOrderConfirmation;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

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
      _loadCookData();
    });

    socket?.on('orderCook', (data) {
      if (mounted) {
        print('Received Cook order event : $data');
        setState(() {
          cookOrderConfirmation = data['message'];
        });
        if (mounted) {
          _playNotificationSound(); // Play sound
          _showOrderConfirmationSnackbar("ອໍເດີເຂົ້າໃຫມ່");
          _loadCookData();
        }
      }
    });

    socket?.onDisconnect((_) {
      print('disconnected from CookPage');
    });

    _loadCookData();
  }

  @override
  void dispose() {
    socket?.disconnect();
    _audioPlayer.dispose(); // Dispose AudioPlayer
    super.dispose();
  }

  Future<void> _loadCookData() async {
    try {
      if (mounted) {
        final providerService =
            Provider.of<ProviderService>(context, listen: false);
        await providerService.getCookPageApi(2);
      }
    } catch (e) {
      // Handle any errors that might occur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cook data: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showOrderConfirmationSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Optionally handle the 'OK' button press
          },
        ),
      ),
    );
  }

  void _playNotificationSound() async {
    // Play the notification sound
    await _audioPlayer.play(AssetSource('./assets/audio/i_phone_ding.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final cookList = providerService.cookList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "${MyData.cookName.toString()} ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: cookList.isNotEmpty
          ? ListView.builder(
              itemCount: cookList.length,
              itemBuilder: (context, index) {
                final cookOrder = cookList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      cookOrder.productPathApi.toString(),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cookOrder.fullName.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${cookOrder.orderListPrice}'),
                        Text('Remark: ${cookOrder.orderListNoteRemark}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // providerService.acceptCookOrder(cookOrder.id);
                      },
                      child: const Text('Accept'),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No new Cook orders'),
            ),
    );
  }
}
