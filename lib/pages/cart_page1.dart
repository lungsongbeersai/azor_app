import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/models/cart_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CartPage1 extends StatefulWidget {
  const CartPage1({super.key});

  @override
  State<CartPage1> createState() => _CartPage1State();
}

class _CartPage1State extends State<CartPage1> {
  IO.Socket? socket;
  double bottomSize = 120;
  String tableID = "";

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://api-azor.plc.la:8091', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();

    socket?.onConnect((_) {
      print('connected');
    });

    socket?.onDisconnect((_) {
      print('disconnected');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as String?;
      if (arguments != null) {
        final args = arguments.split(',');
        if (args.isNotEmpty) {
          tableID = args[0];
          final providerService =
              Provider.of<ProviderService>(context, listen: false);
          _fetchCartData(providerService);
        }
      }
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  Future<void> _fetchCartData(ProviderService providerService) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await providerService.getCart(tableID, "1");
      await providerService.getCartList(tableID, "1");
    } catch (e) {
      print('Error fetching cart data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCart() async {
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    try {
      await providerService.getCart(tableID, "1");
      await providerService.getCartList(tableID, "1");
    } catch (e) {
      print('Error refreshing cart: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final carts = providerService.cartList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ກະຕ໋າຂອງຂ້ອຍ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.print),
              iconSize: 30,
              onPressed: () async {
                final orderListCodes = providerService.cartList
                    .map((item) => item.orderListCode.toString())
                    .toList();
                final status = providerService.cartList
                    .map((item) => item.orderListStatusCook)
                    .toList();

                if (orderListCodes.isNotEmpty) {
                  try {
                    final isSuccess = await providerService.getConfirm(
                        orderListCodes, status);

                    if (isSuccess) {
                      await providerService.getCart(tableID, "1");
                      await providerService.getCartList(tableID, "1");

                      print('Emitting order event with codes: $orderListCodes');
                      print('With status: $status');

                      socket?.emit('order', {
                        'orderListCodes': orderListCodes,
                        'status': status,
                      });

                      AwesomeDialog(
                        context: context,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: true,
                        dialogType: DialogType.success,
                        showCloseIcon: true,
                        title: 'ແຈ້ງເຕືອນ',
                        desc: 'ຢືນຢັນອໍເດີສໍາເລັດແລ້ວ',
                        btnOkText: 'ປິດ',
                        btnOkIcon: Icons.check_circle,
                      ).show();
                    } else {
                      // Handle failure scenario if needed
                    }
                  } catch (e) {
                    print('Error processing order: $e');
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    headerAnimationLoop: true,
                    title: 'ແຈ້ງເຕືອນ',
                    desc: 'ກະຕ໋າຂອງທ່ານ ຍັງບໍ່ມີຂໍໍມູນ',
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red,
                    btnOkText: 'ປິດ',
                  ).show();
                }
              },
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: _refreshCart,
            child: _isLoading
                ? _buildLoadingIndicator()
                : _buildTabContent(carts, 1, providerService),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return CardLoading(
          height: 100,
          width: double.infinity,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.symmetric(vertical: 8),
        );
      },
    );
  }

  Widget _buildTabContent(
      List<CartModels> carts, int status, ProviderService providerService) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - bottomSize - 80,
            child: carts.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final item = carts[index];
                      return GestureDetector(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 95,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage(
                                        width: 100,
                                        height: 100,
                                        placeholder: const AssetImage(
                                          "assets/images/loading_plaholder.gif",
                                        ),
                                        image: NetworkImage(
                                          item.productPathApi ?? '',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.fullName ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${MyData.formatnumber(item.orderListPrice ?? '0')} x ${item.orderListQty ?? 0}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black45,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 1),
                                              child: Text(
                                                "${MyData.formatnumber(item.orderListTotal ?? '0')}₭",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.redAccent,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      size: 16),
                                                  onPressed: () {
                                                    EasyLoading.show(
                                                        status: 'Deleting...');
                                                    providerService
                                                        .getDeleteCart(
                                                            item.orderListCode ??
                                                                '',
                                                            tableID.toString(),
                                                            '1')
                                                        .then((_) {
                                                      EasyLoading.dismiss();
                                                    }).catchError((e) {
                                                      // Handle exceptions if needed
                                                      print(
                                                          'Error deleting cart item: $e');
                                                      EasyLoading.dismiss();
                                                    });
                                                  },
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: SizedBox(
                                                    width: 32,
                                                    height: 32,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          size: 16),
                                                      onPressed: () {
                                                        if (item.orderListQty !=
                                                                null &&
                                                            item.orderListQty! >
                                                                1) {
                                                          EasyLoading.show(
                                                              status:
                                                                  'Updating...');
                                                          providerService
                                                              .getupdateCart(
                                                                  item.orderListCode ??
                                                                      '',
                                                                  item.orderListPercented ??
                                                                      0,
                                                                  'decrease',
                                                                  tableID,
                                                                  '1')
                                                              .then((_) {
                                                            EasyLoading
                                                                .dismiss();
                                                          }).catchError((e) {
                                                            // Handle exceptions if needed
                                                            print(
                                                                'Error updating cart item: $e');
                                                            EasyLoading
                                                                .dismiss();
                                                          });
                                                        }
                                                      },
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${item.orderListQty}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: SizedBox(
                                                    width: 32,
                                                    height: 32,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.add,
                                                          size: 16),
                                                      onPressed: () {
                                                        EasyLoading.show(
                                                            status:
                                                                'Updating...');
                                                        providerService
                                                            .getupdateCart(
                                                                item.orderListCode ??
                                                                    '',
                                                                item.orderListPercented ??
                                                                    0,
                                                                'increase',
                                                                tableID,
                                                                '1')
                                                            .then((_) {
                                                          EasyLoading.dismiss();
                                                        }).catchError((e) {
                                                          // Handle exceptions if needed
                                                          print(
                                                              'Error updating cart item: $e');
                                                          EasyLoading.dismiss();
                                                        });
                                                      },
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
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
                              Icon(Icons.shopping_cart_rounded, size: 70),
                              Text("( ບໍ່ມີລາຍການ )")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ລວມຍອດ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${MyData.formatnumber(providerService.cartNetTotal)}₭",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
