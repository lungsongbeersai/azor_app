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

  @override
  void initState() {
    super.initState();

    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getCategory(0);

    providerService.getProduct('0', '', 0);

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: SizedBox(
          height: 100,
          width: 100,
          child: IconButton(
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
        ),
        title: Text(
          "ເບີໂຕະ ${tableName.toString()}",
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
              Navigator.pushNamed(context, "search");
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
              height: 165,
              child: PageView.builder(
                itemCount: (categoryList.length / 8).ceil(),
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * 8;
                  final endIndex = startIndex + 8;
                  final sublist = categoryList.sublist(
                    startIndex,
                    endIndex < categoryList.length
                        ? endIndex
                        : categoryList.length,
                  );

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
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
                                '${item.cateIcon}',
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

                          int crossAxisCount;
                          if (maxWidth >= 1200) {
                            crossAxisCount = 5;
                          } else if (maxWidth >= 840) {
                            crossAxisCount = 4;
                          } else if (maxWidth >= 600) {
                            crossAxisCount = 3;
                          } else {
                            crossAxisCount = 2;
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
                                  Navigator.pushNamed(
                                    context,
                                    "product_detail",
                                    arguments:
                                        '${item.productId},${tableCode.toString()}',
                                  );
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
                                            height: 170,
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
                                                child: Text(
                                                  '10%',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                  fontSize: 15,
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
                              ;
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
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              Navigator.pushNamed(
                context,
                "shopping_cart",
              );
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
