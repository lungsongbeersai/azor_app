import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:azor/models/product_getid_models.dart';
import 'package:azor/services/provider_service.dart';
import 'package:azor/shared/myData.dart';

class ProductDetailNoset extends StatefulWidget {
  const ProductDetailNoset({Key? key}) : super(key: key);

  @override
  _ProductDetailNosetState createState() => _ProductDetailNosetState();
}

class _ProductDetailNosetState extends State<ProductDetailNoset> {
  late Future<List<ProductGetid>> _productFuture;
  String proID = '';
  String tableCode = '';
  ProductArray? selectedDT;
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
        tableCode = args[1];
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
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder<List<ProductGetid>>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Image.asset(
                    "assets/images/my_loding.gif",
                    width: 100,
                  ),
                );
              } else {
                final products = snapshot.data!;
                final item = products.firstWhere(
                  (product) => product.productId == proID,
                  orElse: () => ProductGetid(
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
                              Stack(
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
                                ],
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: item.productArray?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final detail = item.productArray?[index];

                                      if (detail == null) {
                                        return const SizedBox.shrink();
                                      }
                                      return _buildSizeOption(
                                        detail.sizeName.toString(),
                                        detail.proDetailCode.toString(),
                                        detail.sPrice.toString(),
                                        detail.proDetailGift.toString(),
                                        detail.productCutStock.toString(),
                                        detail.proDetailQty.toString(),
                                        providerService.selectedSize,
                                        (newSize) {
                                          providerService
                                              .updateSelectedSize(newSize);
                                          setState(() {
                                            selectedDT = detail;
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
                                autofocus: false,
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
                            onPressed: selectedDT != null
                                ? () async {
                                    EasyLoading.show(status: 'ປະມວນຜົນ...');
                                    final isSuccess =
                                        await providerService.addCart(
                                            tableCode,
                                            MyData.branchCode,
                                            selectedDT!.proDetailCode
                                                .toString(),
                                            selectedDT!.sPrice.toString(),
                                            int.parse(providerService.quantity
                                                .toString()),
                                            int.parse(selectedDT!.proDetailGift
                                                .toString()),
                                            selectedDT!.productCutStock
                                                .toString(),
                                            textlController.text,
                                            MyData.usersID,
                                            '1001',
                                            "off");
                                    if (isSuccess) {
                                      providerService.resetSelectedSize();
                                      setState(() {
                                        selectedDT = null;
                                      });
                                      textlController.clear();
                                      textlFocusNode.unfocus();
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: true,
                                        dialogType: DialogType.success,
                                        showCloseIcon: true,
                                        title: 'ແຈ້ງເຕືອນ',
                                        desc: 'ເພີ່ມເຂົ້າກະຕ໋າສໍາເລັດແລ້ວ',
                                        btnOkText: 'ປິດ',
                                        btnOkIcon: Icons.check_circle,
                                      ).show();
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        headerAnimationLoop: true,
                                        title: 'ແຈ້ງເຕືອນ',
                                        desc: 'ເພີ່ມຂໍ້ມູນບໍ່ສໍາເລັດ',
                                        btnOkIcon: Icons.cancel,
                                        btnOkColor: Colors.red,
                                        btnOkText: 'ປິດ',
                                      ).show();
                                    }
                                  }
                                : () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      headerAnimationLoop: true,
                                      title: 'ແຈ້ງເຕືອນ',
                                      desc: 'ກະລຸນາເລືອກຢ່າງນ້ອຍ 1 ລາຍການ',
                                      btnOkOnPress: () {},
                                      btnOkIcon: Icons.cancel,
                                      btnOkColor: Colors.red,
                                      btnOkText: 'ປິດ',
                                    ).show();
                                  },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.blue,
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'ເພີ່ມໃສ່ກະຕ໋າ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
      ),
    );
  }

  Widget _buildSizeOption(
    String size,
    String sizeValue,
    String price,
    String discount,
    String cutStock,
    String qty,
    String selectedSize,
    Function(String) onSizeChanged,
  ) {
    double originalPrice = double.tryParse(price) ?? 0;
    double discountValue = double.tryParse(discount) ?? 0;
    double discountedPrice =
        originalPrice - (originalPrice * (discountValue / 100));
    int quantity = int.tryParse(qty) ?? 0;
    bool isOutOfStock = cutStock == "on" && quantity <= 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
        color: isOutOfStock ? Colors.red[100] : Colors.white,
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              discountValue > 0 ? '$size ($discount%)' : size,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              isOutOfStock ? 'ໝົດແລ້ວ: $quantity' : "ຄົງເຫຼືອ: $quantity",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        subtitle: discountValue > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${MyData.formatnumber(originalPrice)}₭',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    '${MyData.formatnumber(discountedPrice)}₭',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            : Text(
                '${MyData.formatnumber(originalPrice)}₭',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
        leading: isOutOfStock
            ? const SizedBox.shrink()
            : Transform.scale(
                scale:
                    1.8, // Increase this value to make the radio button bigger
                child: Radio<String>(
                  value: sizeValue,
                  groupValue: selectedSize,
                  onChanged: (String? newSize) {
                    if (newSize != null) {
                      onSizeChanged(newSize);
                    }
                  },
                  activeColor: Colors.blue, // Radio button color
                ),
              ),
        selected: selectedSize == sizeValue,
        selectedTileColor: const Color.fromARGB(255, 234, 234, 234),
        onTap: isOutOfStock
            ? null
            : () {
                onSizeChanged(sizeValue);
              },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      ),
    );
  }
}
