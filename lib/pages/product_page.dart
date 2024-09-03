import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isLoading = true;
  bool showScrollToTopButton = false;
  final ScrollController _scrollController = ScrollController();
  String tableID = "";
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tableCode = ModalRoute.of(context)?.settings.arguments as String?;
    if (tableCode != null) {
      final args = tableCode.split(',');
      if (args.isNotEmpty) {
        tableID = args[0];
      }
    }
    Provider.of<ProviderService>(context).getCartList(tableID, '1');
  }

  @override
  void initState() {
    super.initState();

    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getCategory(0);
    providerService.getProduct('0', '', 0);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >= 300) {
        setState(() {
          showScrollToTopButton = true;
        });
      } else {
        setState(() {
          showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    String tableCode = '';
    String tableName = '';

    if (arguments != null) {
      final args = arguments.split(',');
      tableCode = args[0];
      tableName = args[1];
    }

    final providerService = Provider.of<ProviderService>(context);
    final categoryList = providerService.categoryList;
    final productList = providerService.productList;

    final maxWidth1 = MediaQuery.of(context).size.width;
    double maxHeight1;

    int crossAxisCount1;
    int page;

    if (maxWidth1 >= 1200) {
      crossAxisCount1 = 12;
      maxHeight1 = 100;
      page = 12;
      // print("result5");
    } else if (maxWidth1 >= 840) {
      crossAxisCount1 = 4;
      maxHeight1 = 210;
      page = 11;
      // print("result4");
    } else if (maxWidth1 >= 600) {
      crossAxisCount1 = 9;
      maxHeight1 = 90;
      page = 9;
      // print("result3");
    } else {
      crossAxisCount1 = 4;
      // print("result2");
      maxHeight1 = 172;
      page = 8;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: ClipOval(
            child: Container(
              color: Colors.white.withOpacity(0.1),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
        ),
        title: Text(
          "ເບີໂຕະ $tableName",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "search",
                arguments: ' ${tableCode.toString()} ',
              );
            },
            icon: const ClipOval(
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: 170,
              height: maxHeight1,
              child: PageView.builder(
                itemCount: (categoryList.length / page).ceil(),
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * page;
                  final endIndex = startIndex + page;
                  final sublist = categoryList.sublist(
                    startIndex,
                    endIndex < categoryList.length
                        ? endIndex
                        : categoryList.length,
                  );

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: sublist.length,
                    itemBuilder: (context, index) {
                      final item = sublist[index];
                      return GestureDetector(
                        onTap: () {
                          EasyLoading.show(status: 'ປະມວນຜົນ...');
                          providerService.getProduct(
                              item.cateCode.toString(), '1', index);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(2),
                          color: providerService.selectedIndex == index
                              ? Colors.blue
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.network(
                                item.cateIcon.toString(),
                                colorFilter: ColorFilter.mode(
                                  providerService.selectedIndex != index
                                      ? Colors.black
                                      : Colors.white,
                                  BlendMode.srcIn,
                                ),
                                height: 24.0,
                                width: 24.0,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                item.cateName.toString(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: providerService.selectedIndex != index
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ລາຍການ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.sort),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    providerService.getCategory(0);
                    providerService.getProduct('', '', 0);
                  });
                },
                child: productList.isNotEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          double maxHeight;

                          int crossAxisCount;

                          if (maxWidth >= 1200) {
                            crossAxisCount = 5;
                            maxHeight = 260;
                            // print("result5");
                          } else if (maxWidth >= 840) {
                            crossAxisCount = 4;
                            maxHeight = 210;
                            // print("result4");
                          } else if (maxWidth >= 600) {
                            crossAxisCount = 3;
                            maxHeight = 270;
                            // print("result3");
                          } else {
                            crossAxisCount = 2;
                            // print("result2");
                            maxHeight = 170;
                          }

                          return GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: productList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (isLoading) {
                                return const CardLoading(
                                  height: 100,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  margin: EdgeInsets.all(1),
                                );
                              }

                              final item = productList[index];
                              return GestureDetector(
                                onTap: () {
                                  if (item.productSet == "on") {
                                    Navigator.pushNamed(
                                      context,
                                      "product_detail_set",
                                      arguments:
                                          '${item.productId},${tableCode.toString()}',
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      "product_detail_no_set",
                                      arguments:
                                          '${item.productId},${tableCode.toString()}',
                                    );
                                  }
                                },
                                child: Container(
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
                                      Stack(
                                        children: [
                                          Container(
                                            height: maxHeight,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(item
                                                    .productPathApi
                                                    .toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          if (item.productDiscount == "on")
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  'ສ່ວນຫຼຸດ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          // Positioned(
                                          //   bottom: 8,
                                          //   left: 8,
                                          //   child: Container(
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             horizontal: 12,
                                          //             vertical: 6),
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.black
                                          //           .withOpacity(0.4),
                                          //       borderRadius:
                                          //           BorderRadius.circular(8),
                                          //     ),
                                          //     child: Text(
                                          //       'fff',
                                          //       style: const TextStyle(
                                          //         color: Colors.white,
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
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
                                                item.productName.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showScrollToTopButton)
            FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: _scrollToTop,
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 30,
              ),
            ),
          const SizedBox(height: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    "tap_cart",
                    arguments: ' ${tableCode.toString()} ',
                  );
                },
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: providerService.cartList.isNotEmpty
                        ? Colors.red
                        : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${providerService.itemCount} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
