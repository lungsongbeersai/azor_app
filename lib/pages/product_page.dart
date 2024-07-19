import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart';
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
    providerService.getCategory();

    Future.delayed(Duration(seconds: 3), () {
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
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  final List<int> dataList = List.generate(13, (index) => index + 1);

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
                      return Card(
                        margin: const EdgeInsets.all(2),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(
                            //   Icons.sort,
                            //   size: 24,
                            //   color: item == 1 ? Colors.white : Colors.black,
                            // ),
                            SvgPicture.network(
                              'https://example.com/path/to/your/search.svg',
                              color: item == 1 ? Colors.white : Colors.black,
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
                                color: item == 1 ? Colors.white : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                  setState(() {});
                },
                child: LayoutBuilder(
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 0.78, // Adjust as needed
                      ),
                      itemCount: 1000,
                      itemBuilder: (BuildContext context, int index) {
                        if (isLoading) {
                          return const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            margin: EdgeInsets.all(1),
                          );
                        }

                        final productName = 'ເບຍລາວແກ້ວໃຫຍ່ 150 mol';
                        String images = "";
                        print("result:${index}");
                        if (index == 0) {
                          images = "assets/images/khao.JPG";
                        } else if (index == 1) {
                          images = "assets/images/beer.png";
                        } else if (index == 2) {
                          images = "assets/images/beerlao.jpg";
                        } else if (index == 3) {
                          images = "assets/images/watter.jpeg";
                        } else if (index == 4) {
                          images = "assets/images/pepsi.jpeg";
                        } else {
                          images = "assets/images/azor.jpg";
                        }
                        return GestureDetector(
                          onTap: () {
                            // Handle product tap
                            Navigator.pushNamed(
                              context,
                              "detail",
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // color: Color.fromARGB(255, 249, 247, 235),
                              border: Border.all(
                                  color: Color.fromARGB(255, 244, 242, 242)),
                              // borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image (replace with actual image widget)
                                Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.only(
                                    //   topLeft: Radius.circular(8),
                                    //   topRight: Radius.circular(8),
                                    // ),
                                    image: DecorationImage(
                                      image: AssetImage('${images}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product name
                                      const SizedBox(height: 4),
                                      Text(
                                        productName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
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
