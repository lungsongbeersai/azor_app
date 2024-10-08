import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();

    // socket = IO.io('http://api-azor.plc.la:8091', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });

    // socket?.connect();

    // socket?.onConnect((_) {
    //   print('connected');
    // });

    // socket?.onDisconnect((_) {
    //   print('disconnected');
    // });

    // socket?.onError((error) {
    //   print('Socket error: $error');
    // });

    // // Listen for 'EmitCookConfirm' event
    // socket?.on('EmitCookConfirm', (data) {
    //   if (mounted) {
    //     print('EmitCookConfirm event received: $data');
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(data['message'])),
    //     );
    //   }
    // });

    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getZone();
    providerService.getTable();
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth1 = MediaQuery.of(context).size.width;
    int crossAxisCount1;

    if (maxWidth1 >= 1200) {
      crossAxisCount1 = 10;
    } else if (maxWidth1 >= 840) {
      crossAxisCount1 = 8;
    } else if (maxWidth1 >= 600) {
      crossAxisCount1 = 5;
    } else {
      crossAxisCount1 = 3;
    }

    final providerService = Provider.of<ProviderService>(context);
    final zoneList = providerService.zoneList;
    final tableList = providerService.tableList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "ລາຍການໂຕະ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.topSlide,
                title: 'ແຈ້ງເຕືອນ',
                desc: 'ກົດ "ຕົກລົງ" ເພື່ອອອກຈາກລະບົບ?',
                btnCancelText: 'ປິດໜ້າຕ່າງ',
                btnOkText: 'ຕົກລົງ',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await providerService.logout();
                  exit(0);
                },
              ).show();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: zoneList.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        EasyLoading.show(status: 'ປະມວນຜົນ...');
                        providerService.getTableGetId(
                          MyData.branchCode,
                          '',
                          index,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: providerService.selectedIndex != index
                              ? const Color(0xFFEBEAEA)
                              : const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'ທັງໝົດ',
                          style: TextStyle(
                            color: providerService.selectedIndex != index
                                ? const Color(0xFF606060)
                                : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final item = zoneList[index - 1];
                    return GestureDetector(
                      onTap: () {
                        EasyLoading.show(status: 'ປະມວນຜົນ...');
                        providerService.getTableGetId(
                          MyData.branchCode,
                          item.zoneCode.toString(),
                          index,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: providerService.selectedIndex != index
                              ? const Color(0xFFEBEAEA)
                              : const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item.zoneName.toString(),
                          style: TextStyle(
                            color: providerService.selectedIndex != index
                                ? const Color(0xFF606060)
                                : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    providerService.getPullRefresh();
                  });
                },
                child: tableList.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1,
                        ),
                        itemCount: tableList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = tableList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "table_id",
                                arguments:
                                    '${item.tableCode},${item.tableName}',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: item.tableStatus == "2"
                                    ? const Color.fromARGB(255, 246, 248, 230)
                                    : Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${item.tableName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 70,
                                  ),
                                  Text("( ບໍ່ມີຂໍ້ມູນ")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
