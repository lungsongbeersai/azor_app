import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  double bottomSize = 20;
  String tableID = "";
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    if (arguments != null) {
      final args = arguments.split(',');
      if (args.isNotEmpty) {
        tableID = args[0];
        final providerService =
            Provider.of<ProviderService>(context, listen: false);
        providerService.getCart(tableID.toString(), MyData.branchCode);
        providerService.getCartList(tableID.toString());
      }
    }
  }

  Future<void> updateCart(List<String> orderListCodes) async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('http://api-azor.plc.la/update_cart');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'order_list_code': orderListCodes});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Handle success
          print('Update success!');
        } else {
          // Handle other statuses
          print('Update failed: ${data['status']}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Update failed: ${data['status']}'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // Handle other HTTP status codes
        print('Request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Request failed with status: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      // Handle network or server errors
      print('Error updating cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating cart: $error'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          MediaQuery.of(context).padding.top -
                          kBottomNavigationBarHeight -
                          bottomSize,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
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
                                        SizedBox(
                                          height: 100,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: FadeInImage(
                                                    placeholder:
                                                        const AssetImage(
                                                      "assets/images/loading_placeholder.gif",
                                                    ),
                                                    width: 100,
                                                    height: 105,
                                                    image: NetworkImage(
                                                      item.productPathApi
                                                          .toString(),
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
                                                    Container(
                                                      child: Text(
                                                        item.fullName
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${MyData.formatnumber(item.orderListPrice.toString())} x ${item.orderListQty}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black45,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 1),
                                                          child: Text(
                                                            "${MyData.formatnumber(item.orderListTotal.toString())}₭",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .redAccent,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: SizedBox(
                                                            width: 32,
                                                            height: 32,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  size: 16),
                                                              onPressed: () {
                                                                providerService
                                                                    .getDeleteCart(
                                                                  item.orderListCode
                                                                      .toString(),
                                                                  tableID
                                                                      .toString(),
                                                                );
                                                              },
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: SizedBox(
                                                                width: 32,
                                                                height: 32,
                                                                child:
                                                                    IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 16),
                                                                  onPressed:
                                                                      () {
                                                                    if (item.orderListQty ==
                                                                        1) {
                                                                      return;
                                                                    }
                                                                    providerService
                                                                        .getupdateCart(
                                                                      item.orderListCode
                                                                          .toString(),
                                                                      item.orderListPercented ??
                                                                          0,
                                                                      'decrease',
                                                                      tableID,
                                                                    );
                                                                  },
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                item.orderListQty
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: SizedBox(
                                                                width: 32,
                                                                height: 32,
                                                                child:
                                                                    IconButton(
                                                                  icon: const Icon(
                                                                      Icons.add,
                                                                      size: 16),
                                                                  onPressed:
                                                                      () {
                                                                    providerService
                                                                        .getupdateCart(
                                                                      item.orderListCode
                                                                          .toString(),
                                                                      item.orderListPercented ??
                                                                          0,
                                                                      'increase',
                                                                      tableID,
                                                                    );
                                                                  },
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            )
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
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "ບໍ່ມີລາຍການ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ລວມທັງໝົດ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            MyData.formatnumber(providerService.cartNetTotal),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (isLoading) {
                            return;
                          }

                          List<String> orderListCodes = providerService.cartList
                              .map((item) => item.orderListCode.toString())
                              .toList();

                          await updateCart(orderListCodes);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                "ສັ່ງຊື້",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
    );
  }
}
