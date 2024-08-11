import 'package:azor/models/cart_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage3 extends StatefulWidget {
  const CartPage3({super.key});

  @override
  State<CartPage3> createState() => _CartPage3State();
}

class _CartPage3State extends State<CartPage3> {
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
          providerService.getCart(tableID, '3');
          providerService.getCartList(tableID, '3');
        }
      }
    });
  }

  Future<void> _refreshCart() async {
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    await providerService.getCart(tableID, '3');
    await providerService.getCartList(tableID, '3');
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final carts = providerService.cartList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ສໍາເລັດແລ້ວ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: _refreshCart,
            child: _buildTabContent(carts, 2, providerService),
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
                                            fontSize: 16,
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
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    item.usersName.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: GestureDetector(
                                                    child: Image.asset(
                                                      'assets/images/free-check.png',
                                                      fit: BoxFit.cover,
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
