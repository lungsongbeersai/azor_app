import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String tableID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getProductSearch("");
  }

  void _onSearchPressed() async {
    EasyLoading.show(status: 'ປະມວນຜົນ...');
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.clearProductList();

    await providerService.getProductSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);
    final productList = providerService.proName;

    final tableCode = ModalRoute.of(context)?.settings.arguments as String?;
    if (tableCode != null) {
      final args = tableCode.split(',');
      if (args.isNotEmpty) {
        tableID = args[0];
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(right: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'ຄົ້ນຫາ...',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black54),
                onPressed: _onSearchPressed,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await providerService
                        .getProductSearch(_searchController.text);
                  },
                  child: productList.isEmpty
                      ? const Center(child: Text('ຄົ້ນຫາ...'))
                      : ListView.builder(
                          itemCount: productList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = productList[index];
                            return GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SizedBox(
                                          height: 110,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: FadeInImage(
                                                    width: 100,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2,
                                                    placeholder: const AssetImage(
                                                        "assets/images/image_placeholder.png"),
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
                                                    Text(
                                                      item.productName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Expanded(
                                                      child: Text(""),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Flexible(
                                                          child: Text(
                                                            "",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (item.productSet ==
                                                                "on") {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                "product_detail_set",
                                                                arguments:
                                                                    '${item.productId},${tableCode}',
                                                              );
                                                            } else {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                "product_detail_no_set",
                                                                arguments:
                                                                    '${item.productId},${tableCode}',
                                                              );
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                          child: const Icon(Icons
                                                              .shopping_cart),
                                                        ),
                                                      ],
                                                    ),
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
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
