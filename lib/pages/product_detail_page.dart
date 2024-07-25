import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azor/models/product_getID_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<List<ProductGetId>> _productFuture;
  String proID = '';
  ProductArray? selectedDetail;
  FocusNode textlFocusNode = FocusNode();
  TextEditingController textlController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    if (arguments != null) {
      final args = arguments.split(',');
      if (args.isNotEmpty) {
        proID = args[0];
      }
    }
    _productFuture = Provider.of<ProviderService>(context).getProductID(proID);
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ລາຍລະອຽດ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder<List<ProductGetId>>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Image.asset(
                  "assets/images/image_placeholder.png",
                  width: 100,
                ),
              );
            } else {
              final products = snapshot.data!;
              final item = products.firstWhere(
                (product) => product.productId == proID,
                orElse: () => ProductGetId(
                  productId: 'N/A',
                  productName: 'N/A',
                  productPathApi: '',
                  productArray: [],
                ),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 260,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      item.productPathApi.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                item.productName.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "ຕົວເລືອກ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer<ProviderService>(
                              builder: (context, providerService, child) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: item.productArray?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final detail = item.productArray?[index];
                                    if (detail == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return _buildSizeOption(
                                      detail.sizeName.toString(),
                                      detail.proDetailCode.toString(),
                                      MyData.formatnumber(detail.sPrice),
                                      providerService.selectedSize,
                                      (newSize) {
                                        providerService
                                            .updateSelectedSize(newSize);
                                        setState(() {
                                          selectedDetail = detail;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "ໝາຍເຫດ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextFormField(
                              controller: textlController,
                              focusNode: textlFocusNode,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                hintText: 'ໝາຍເຫດ',
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: providerService.decrementQuantity,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              providerService.quantity.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: providerService.incrementQuantity,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: selectedDetail != null
                              ? () {
                                  print(
                                      "result: ${selectedDetail!.proDetailCode},${providerService.quantity.toString()},${proID.toString()},${textlController.text}");
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text('ເພີ່ມໃສ່ກະຕ໋າ ສໍາເລັດແລ້ວ'),
                                  //   ),
                                  // );
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'ເພີ່ມໃສ່ກະຕ໋າ',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size, String sizeValue, String price,
      String selectedSize, Function(String) onSizeChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          size,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          price,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        leading: Transform.scale(
          scale: 1.8,
          child: Radio<String>(
            value: sizeValue,
            groupValue: selectedSize,
            onChanged: (String? newSize) {
              if (newSize != null) {
                onSizeChanged(newSize);
              }
            },
          ),
        ),
        selected: selectedSize == sizeValue,
        selectedTileColor: const Color.fromARGB(255, 234, 234, 234),
        onTap: () {
          onSizeChanged(sizeValue);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      ),
    );
  }
}
