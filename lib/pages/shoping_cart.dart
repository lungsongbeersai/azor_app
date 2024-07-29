import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage>
    with SingleTickerProviderStateMixin {
  double bottomSize = 80;
  String tableID = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    if (arguments != null) {
      final args = arguments.split(',');
      if (args.isNotEmpty) {
        tableID = args[0];
      }
    }
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getCart(tableID, MyData.branchCode);
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final carts = providerService.cartList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ກະຕ໋າສິນຄ້າ",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
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
                  child:
                      // carts.isNotEmpty
                      //     ?
                      ListView.separated(
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
                              height: 120,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FadeInImage(
                                        placeholder: const AssetImage(
                                            "assets/images/loading_plaholder.gif"),
                                        width: 100,
                                        height: 105,
                                        image: NetworkImage(
                                            item.productPathApi.toString()),
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
                                            item.fullName.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        // Text("Price:50.000"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${MyData.formatnumber(item.orderListPrice)} x ${item.orderListQty}"),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    "${MyData.formatnumber(item.orderListTotal)} ",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // providerService
                                                //     .getdeleteCart(
                                                //   item.bookUuid.toString(),
                                                // );
                                              },
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    // if (item.cartQty == 1) {
                                                    //   return;
                                                    // }

                                                    // providerService
                                                    //     .getupdateCart(
                                                    //   item.cartBookFk
                                                    //       .toString(),
                                                    //   'decrease',
                                                    // );
                                                    // providerService
                                                    //     .getCartList();
                                                  },
                                                  icon: const Icon(
                                                      Icons.remove_circle),
                                                  iconSize: 30,
                                                  color: Colors.black38,
                                                ),
                                                Container(
                                                  child: Text(
                                                    '${item.orderListQty}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    // providerService
                                                    //     .getupdateCart(
                                                    //   item.cartBookFk
                                                    //       .toString(),
                                                    //   'increase',
                                                    // );
                                                    // providerService
                                                    //     .getCartList();
                                                  },
                                                  icon: const Icon(
                                                      Icons.add_circle),
                                                  iconSize: 30,
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
                      return Divider();
                    },
                  )
                  // : Center(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           padding: EdgeInsets.symmetric(vertical: 10),
                  //           child: const Column(
                  //             children: [
                  //               Icon(
                  //                 Icons.shopping_cart_outlined,
                  //                 size: 70,
                  //               ),
                  //               Text("( ບໍ່ມີລາຍການ )")
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: const Text(
                    "ລວມຍອດ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    // MyData.formatnumber(providerService.cartNetTotal),
                    '10',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "ຊໍາລະເງິນ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }
}
