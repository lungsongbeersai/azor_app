import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/models/cart_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CartPage2 extends StatefulWidget {
  const CartPage2({super.key});

  @override
  State<CartPage2> createState() => _CartPage2State();
}

class _CartPage2State extends State<CartPage2> {
  double bottomSize = 120;
  String tableID = "";
  bool isLoading = true;
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
    //   print('Connected to socket cart2');
    // });

    // socket?.onDisconnect((_) {
    //   print('Disconnected from socket');
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

    // socket?.onDisconnect((_) {
    //   print('disconnected from EmitCookConfirm');
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializePage();
    });
  }

  Future<void> _initializePage() async {
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    if (arguments != null) {
      final args = arguments.split(',');
      if (args.isNotEmpty) {
        tableID = args[0];
      }
    }
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    await providerService.getCart2(tableID);
    await providerService.getCartList2(tableID);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshCart() async {
    setState(() {
      isLoading = true;
    });
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    try {
      await providerService.getCart2(tableID);
      await providerService.getCartList2(tableID);
    } catch (e) {
      print('Error refreshing cart: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final carts = providerService.cartList2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ກໍາລັງເຮັດ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            onPressed: () async {
              _refreshCart();
            },
          ),
        ],
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
            child: isLoading
                ? _buildLoadingIndicator()
                : _buildTabContent(carts, providerService),
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
      List<CartModels> carts, ProviderService providerService) {
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
                      return _buildCartItem(item, index);
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
        _buildBottomSummary(providerService),
      ],
    );
  }

  Widget _buildCartItem(CartModels item, index) {
    return GestureDetector(
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          width: 100,
                          height: 110,
                          placeholder: const AssetImage(
                            "assets/images/loading_plaholder.gif",
                          ),
                          image: NetworkImage(
                            item.productPathApi ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ຄິວ ${item.orderListQ}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${item.fullName} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 60,
                              child: const Text(
                                "ໝາຍເຫດ:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(right: 1),
                              child: Text(
                                "${item.orderListNoteRemark}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: const EdgeInsets.only(right: 1),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     border:
                          //         Border.all(color: Colors.redAccent, width: 2),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          //   child: SizedBox(
                          //     width: 32,
                          //     height: 32,
                          //     child: IconButton(
                          //       icon: const Icon(Icons.delete, size: 16),
                          //       onPressed: () {
                          //         _handleDelete(item);
                          //       },
                          //       color: Colors.redAccent,
                          //     ),
                          //   ),
                          // ),
                          Row(
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: GestureDetector(
                                  child: Image.asset(
                                    'assets/images/cook_loading.gif',
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
  }

  void _handleDelete(CartModels item) {
    EasyLoading.show(status: 'Deleting...');
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    if (item.orderListStatusOrder == 2) {
      providerService
          .getDeleteSccessCart(item.orderListCode ?? '', tableID, '2')
          .then((_) {
        EasyLoading.dismiss();
      }).catchError((e) {
        print('Error deleting: $e');
        EasyLoading.dismiss();
      });
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: true,
        title: 'ແຈ້ງເຕືອນ',
        desc: 'ຂໍອະໄພ ! ອໍເດີນີ້ກໍາລັງຄົວ...',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
        btnOkText: 'ປິດ',
      ).show();
      EasyLoading.dismiss();
    }
  }

  Widget _buildBottomSummary(ProviderService providerService) {
    return Container(
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
                "${MyData.formatnumber(providerService.cartNetTotal2)}₭",
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
    );
  }
}
