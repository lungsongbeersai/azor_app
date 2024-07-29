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
  double bottomSize = 20;
  String tableID = "";

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
        providerService.getCart(tableID, MyData.branchCode);
        providerService.getCartList(tableID);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Container(
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
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: FadeInImage(
                                              placeholder: const AssetImage(
                                                "assets/images/loading_plaholder.gif",
                                              ),
                                              width: 100,
                                              height: 105,
                                              image: NetworkImage(
                                                item.productPathApi.toString(),
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
                                                  item.fullName.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${MyData.formatnumber(item.orderListPrice.toString())} x ${item.orderListQty}"),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 15,
                                                        ),
                                                        child: Text(
                                                          "${MyData.formatnumber(item.orderListTotal.toString())}₭ ",
                                                          style:
                                                              const TextStyle(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.redAccent,
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
                                                            Icons.delete,
                                                            size: 16),
                                                        onPressed: () {
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
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: SizedBox(
                                                          width: 32,
                                                          height: 32,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.remove,
                                                                size: 16),
                                                            onPressed: () {
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
                                                                'increase',
                                                                tableID,
                                                              );
                                                            },
                                                            color: Colors.grey,
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
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: SizedBox(
                                                          width: 32,
                                                          height: 32,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.add,
                                                                size: 16),
                                                            onPressed: () {},
                                                            color: Colors.grey,
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
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 70,
                                    ),
                                    Text("( ບໍ່ມີລາຍການ )")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          )),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        height: 120,
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
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "ລວມຍອດ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    '${MyData.formatnumber(providerService.cartNetTotal)}₭ ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "ຢືນຢັນອໍເດີ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
