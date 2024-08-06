import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/models/cart_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage1 extends StatefulWidget {
  const CartPage1({super.key});

  @override
  State<CartPage1> createState() => _CartPage1State();
}

class _CartPage1State extends State<CartPage1> {
  double bottomSize = 120;
  String tableID = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as String?;
      if (arguments != null) {
        final args = arguments.split(',');
        if (args.isNotEmpty) {
          tableID = args[0];
          final providerService =
              Provider.of<ProviderService>(context, listen: false);
          providerService.getCart(tableID, MyData.branchCode, 1);
          providerService.getCartList(tableID);
          print("result1: ${arguments}");
        }
      }
    });
  }

  Future<void> _refreshCart() async {
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    await providerService.getCart(tableID, MyData.branchCode, 1);
    await providerService.getCartList(tableID);
  }

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

                if (orderListCodes.isNotEmpty) {
                  await providerService.getConfirm(orderListCodes);
                  providerService.getCart(tableID, MyData.branchCode, 1);
                  providerService.getCartList(tableID);
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
              color: Colors.blue, // Icon color
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
            child: _buildTabContent(carts, 1, providerService),
          ),
        ),
      ),
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
                                                    width: 2),
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
                                                    providerService
                                                        .getDeleteCart(
                                                      item.orderListCode ?? '',
                                                      tableID.toString(),
                                                    );
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
                                                          providerService
                                                              .getupdateCart(
                                                            item.orderListCode ??
                                                                '',
                                                            item.orderListPercented ??
                                                                0,
                                                            'decrease',
                                                            tableID,
                                                          );
                                                        }
                                                      },
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    item.orderListQty
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18),
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
                                                        providerService
                                                            .getupdateCart(
                                                          item.orderListCode ??
                                                              '',
                                                          item.orderListPercented ??
                                                              0,
                                                          'increase',
                                                          tableID,
                                                        );
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
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
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
                              Icon(Icons.shopping_cart_outlined, size: 70),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${MyData.formatnumber(providerService.cartNetTotal)}₭",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              // const SizedBox(height: 15),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(10),
              //       ),
              //     ),
              //     minimumSize: const Size.fromHeight(35),
              //   ),
              //   onPressed: () async {
              //     final orderListCodes = providerService.cartList
              //         .map((item) => item.orderListCode.toString())
              //         .toList();

              //     if (orderListCodes.isNotEmpty) {
              //       await providerService.getConfirm(orderListCodes);
              //       providerService.getCart(tableID, MyData.branchCode, 1);
              //       providerService.getCartList(tableID);
              //       AwesomeDialog(
              //         context: context,
              //         animType: AnimType.leftSlide,
              //         headerAnimationLoop: true,
              //         dialogType: DialogType.success,
              //         showCloseIcon: true,
              //         title: 'ແຈ້ງເຕືອນ',
              //         desc: 'ຢືນຢັນອໍເດີສໍາເລັດແລ້ວ',
              //         btnOkText: 'ປິດ',
              //         btnOkIcon: Icons.check_circle,
              //       ).show();
              //     } else {
              //       AwesomeDialog(
              //         context: context,
              //         dialogType: DialogType.error,
              //         animType: AnimType.rightSlide,
              //         headerAnimationLoop: true,
              //         title: 'ແຈ້ງເຕືອນ',
              //         desc: 'ກະຕ໋າຂອງທ່ານ ຍັງບໍ່ມີຂໍໍມູນ',
              //         btnOkIcon: Icons.cancel,
              //         btnOkColor: Colors.red,
              //         btnOkText: 'ປິດ',
              //       ).show();
              //     }
              //   },
              //   child: const Text(
              //     "ຢືນຢັນອໍເດີ",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
