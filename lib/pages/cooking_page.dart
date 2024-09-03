import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_loading/card_loading.dart';

class CookingPage extends StatefulWidget {
  const CookingPage({super.key});

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadCookData();
  }

  Future<void> _loadCookData() async {
    try {
      final providerService =
          Provider.of<ProviderService>(context, listen: false);
      await providerService.getCookPageApi3(3);

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

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final cookList = providerService.cookList3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ກໍາລັງເຮັດ ",
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
                    providerService.getCookPageApi3(3);
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
                            maxHeight = 9;
                          } else if (maxWidth >= 840) {
                            crossAxisCount = 3;
                            maxHeight = 11;
                          } else if (maxWidth >= 600) {
                            crossAxisCount = 2;
                            maxHeight = 11;
                          } else {
                            crossAxisCount = 1;
                            maxHeight = 11;
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
                                                      const Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .wifi_protected_setup_outlined,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            "ຈໍານວນ",
                                                            style: TextStyle(
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
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            "x ${item.orderListQty}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
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
                                              onPressed: () async {
                                                final isSuccess =
                                                    await providerService
                                                        .getApiConfirmCooking(
                                                  4,
                                                  item.orderListCode.toString(),
                                                );
                                                if (isSuccess) {
                                                  providerService
                                                      .getCookPageApi3(3);
                                                }
                                              },
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
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'ຄົວສໍາເລັດ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
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
                                    Icons.shopping_cart,
                                    size: 70,
                                  ),
                                  Text("( ຍັງບໍ່ມີລາຍການ )")
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
