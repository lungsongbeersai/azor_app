import 'package:audioplayers/audioplayers.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:card_loading/card_loading.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isLoading = true;

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
          _playNotificationSound();
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
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadCookData() async {
    try {
      final providerService =
          Provider.of<ProviderService>(context, listen: false);
      await providerService.getCookPageApi(2);

      // Add a delay to simulate loading
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
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
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _playNotificationSound() async {
    // Play the notification sound
    await _audioPlayer.play(AssetSource('audio/i_phone_ding.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final cookList = providerService.cookList;
    double halfScreenWidth = MediaQuery.of(context).size.width / 2;
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    providerService.getPullRefresh();
                  });
                },
                child: cookList.isNotEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          int maxHeight;

                          int crossAxisCount;
                          if (maxWidth >= 1200) {
                            crossAxisCount = 4;
                            maxHeight = 12;
                          } else if (maxWidth >= 840) {
                            crossAxisCount = 3;
                            maxHeight = 13;
                          } else if (maxWidth >= 600) {
                            crossAxisCount = 2;
                            maxHeight = 13;
                          } else {
                            crossAxisCount = 1;
                            maxHeight = 13;
                          }

                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: cookList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (isLoading) {
                                return const CardLoading(
                                  height: 90,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  margin: EdgeInsets.all(1),
                                );
                              }

                              final item = cookList[index];

                              return GestureDetector(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 244, 242, 242),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / maxHeight,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(item
                                                          .productPathApi
                                                          .toString()),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      'ຄິວ ${item.orderListQ}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "${item.fullName}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            "${item.usersName}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.access_time,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            "${item.orderListDateTime}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.comment,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'ໝາຍເຫດ'),
                                                                  content: Text(
                                                                      item.orderListNoteRemark ??
                                                                          'No remarks available'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'ປິດ'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Tooltip(
                                                            message: item
                                                                    .orderListNoteRemark ??
                                                                'No remarks available',
                                                            child: Text(
                                                              "ໝາຍເຫດ: ${item.orderListNoteRemark ?? ''}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                backgroundColor:
                                                    Colors.grey[300],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    0,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'ໂຕະ ${item.tableName}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed:
                                                  index == 0 ? () {} : null,
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: index == 0
                                                        ? Colors.white
                                                        : Colors.black12,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'ຢືນຢັນອໍເດີ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: index == 0
                                                          ? Colors.white
                                                          : Colors.black12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              // return GestureDetector(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       border: Border.all(
                              //         color: const Color.fromARGB(
                              //           255,
                              //           244,
                              //           242,
                              //           242,
                              //         ),
                              //       ),
                              //     ),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         AspectRatio(
                              //           aspectRatio: 16 / maxHeight,
                              //           child: Stack(
                              //             fit: StackFit.expand,
                              //             children: [
                              //               Container(
                              //                 decoration: BoxDecoration(
                              //                   image: DecorationImage(
                              //                     image: NetworkImage(item
                              //                         .productPathApi
                              //                         .toString()),
                              //                     fit: BoxFit.cover,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Align(
                              //                 alignment: Alignment.topRight,
                              //                 child: Container(
                              //                   margin: const EdgeInsets.all(8),
                              //                   padding:
                              //                       const EdgeInsets.symmetric(
                              //                     horizontal: 12,
                              //                     vertical: 6,
                              //                   ),
                              //                   decoration: BoxDecoration(
                              //                     color: Colors.black
                              //                         .withOpacity(0.4),
                              //                     borderRadius:
                              //                         BorderRadius.circular(8),
                              //                   ),
                              //                   child: Text(
                              //                     'ໂຕະ ${item.tableName}',
                              //                     style: const TextStyle(
                              //                       color: Colors.white,
                              //                       fontSize: 16,
                              //                       fontWeight: FontWeight.bold,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Center(
                              //             child: Column(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 const SizedBox(height: 4),
                              //                 Text(
                              //                   "${item.fullName}",
                              //                   style: const TextStyle(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold,
                              //                   ),
                              //                   maxLines: 1,
                              //                   overflow: TextOverflow.ellipsis,
                              //                 ),
                              //                 const SizedBox(height: 15),
                              //                 Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Row(
                              //                       children: [
                              //                         const Icon(
                              //                           Icons.person,
                              //                           size: 20,
                              //                         ),
                              //                         const SizedBox(width: 4),
                              //                         Text(
                              //                           "${item.usersName}",
                              //                           style: const TextStyle(
                              //                             fontSize: 14,
                              //                             fontWeight:
                              //                                 FontWeight.w500,
                              //                           ),
                              //                           maxLines: 1,
                              //                           overflow: TextOverflow
                              //                               .ellipsis,
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     Row(
                              //                       children: [
                              //                         const Icon(
                              //                           Icons.access_time,
                              //                           size: 20,
                              //                         ),
                              //                         const SizedBox(width: 4),
                              //                         Text(
                              //                           "${item.orderListDateTime}",
                              //                           style: const TextStyle(
                              //                             fontSize: 14,
                              //                           ),
                              //                           maxLines: 1,
                              //                           overflow: TextOverflow
                              //                               .ellipsis,
                              //                           textAlign:
                              //                               TextAlign.right,
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 const SizedBox(height: 4),
                              //                 Row(
                              //                   children: [
                              //                     const Icon(
                              //                       Icons.comment,
                              //                       size: 20,
                              //                     ),
                              //                     const SizedBox(width: 4),
                              //                     Expanded(
                              //                       child: GestureDetector(
                              //                         onTap: () {
                              //                           showDialog(
                              //                             context: context,
                              //                             builder: (context) {
                              //                               return AlertDialog(
                              //                                 title: const Text(
                              //                                     'ໝາຍເຫດ'),
                              //                                 content: Text(item
                              //                                         .orderListNoteRemark ??
                              //                                     'No remarks available'),
                              //                                 actions: [
                              //                                   TextButton(
                              //                                     onPressed:
                              //                                         () {
                              //                                       Navigator.of(
                              //                                               context)
                              //                                           .pop();
                              //                                     },
                              //                                     child:
                              //                                         const Text(
                              //                                             'ປິດ'),
                              //                                   ),
                              //                                 ],
                              //                               );
                              //                             },
                              //                           );
                              //                         },
                              //                         child: Tooltip(
                              //                           message: item
                              //                                   .orderListNoteRemark ??
                              //                               'No remarks available',
                              //                           child: Text(
                              //                             "ໝາຍເຫດ: ${item.orderListNoteRemark ?? ''}",
                              //                             style:
                              //                                 const TextStyle(
                              //                               fontSize: 14,
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                             ),
                              //                             maxLines: 1,
                              //                             overflow: TextOverflow
                              //                                 .ellipsis,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 const SizedBox(height: 10),
                              //                 Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     SizedBox(
                              //                       child: ElevatedButton(
                              //                         onPressed: () {
                              //                           // Add left button action here
                              //                         },
                              //                         style: ElevatedButton
                              //                             .styleFrom(
                              //                           backgroundColor:
                              //                               const Color
                              //                                   .fromARGB(221,
                              //                                   244, 239, 239),
                              //                           foregroundColor:
                              //                               Colors.black,
                              //                           shape:
                              //                               RoundedRectangleBorder(
                              //                             borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(2),
                              //                           ),
                              //                         ),
                              //                         child: Text(
                              //                           "ຄິວ ${item.orderListQ}",
                              //                           style: const TextStyle(
                              //                             fontSize: 20,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     const SizedBox(width: 5),
                              // SizedBox(
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       // Add checkout action here
                              //     },
                              //     style: ElevatedButton
                              //         .styleFrom(
                              //       backgroundColor:
                              //           Colors.green,
                              //       foregroundColor:
                              //           Colors.white,
                              //       shape:
                              //           RoundedRectangleBorder(
                              //         borderRadius:
                              //             BorderRadius
                              //                 .circular(2),
                              //       ),
                              //     ),
                              //     child: const Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment
                              //               .center,
                              //       children: [
                              //         Icon(
                              //           Icons.check,
                              //           color: Colors.white,
                              //           size: 20,
                              //         ),
                              //         SizedBox(width: 4),
                              //         Text(
                              //           "ຢືນຢັນອໍເດີ",
                              //           style: TextStyle(
                              //             fontSize: 14,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // );
                            },
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
                                  Text("( ບໍ່ມີຂໍ້ມູນ )")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
