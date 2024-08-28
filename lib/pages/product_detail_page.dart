import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:azor/models/product_getid_models.dart';
import 'package:azor/services/provider_service.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<bool> checkboxStates = [];
  String proID = '';
  String tableCode = '';
  FocusNode textlFocusNode = FocusNode();
  TextEditingController textlController = TextEditingController();
  int selectedCount = 0; // Track the number of selected checkboxes

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as String?;
    if (arguments != null) {
      final args = arguments.split(',');
      if (args.length >= 2) {
        proID = args[0];
        tableCode = args[1];
      }
    }

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
        child: FutureBuilder<List<ProductGetid>>(
          future: providerService.getProductID(proID),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final item = snapshot.data!.first;

              // Ensure checkboxStates is initialized properly
              if (checkboxStates.length != (item.productArray?.length ?? 0)) {
                checkboxStates =
                    List<bool>.filled(item.productArray?.length ?? 0, true);
                selectedCount = 0; // Reset selected count
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/image_placeholder.png",
                                image: item.productPathApi.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              item.productName.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Center(
                            child: Text(
                              "10000 ກີບ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ຕົວເລືອກ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: item.productArray?.length ?? 0,
                            itemBuilder: (context, index) {
                              final detail = item.productArray?[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (checkboxStates[index]) {
                                          // Uncheck the checkbox
                                          checkboxStates[index] = false;
                                          selectedCount--;
                                        } else if (selectedCount < 200) {
                                          // Check the checkbox if the limit is not reached
                                          checkboxStates[index] = true;
                                          selectedCount++;
                                        } else {
                                          // Show a dialog if the limit is reached
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'ເລືອກໄດ້ບໍ່ເກີນ 3 ລາຍການ',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MSHCheckbox(
                                            size: 40,
                                            value: checkboxStates[index],
                                            colorConfig: MSHColorConfig
                                                .fromCheckedUncheckedDisabled(
                                              checkedColor: Colors.blue,
                                            ),
                                            style: MSHCheckboxStyle.stroke,
                                            onChanged: (selected) {
                                              setState(() {
                                                if (selected!) {
                                                  checkboxStates[index] =
                                                      selected;
                                                  selectedCount++;
                                                  // if (selectedCount < 3) {
                                                  //   checkboxStates[index] =
                                                  //       selected;
                                                  //   selectedCount++;
                                                  // } else {
                                                  //   ScaffoldMessenger.of(
                                                  //           context)
                                                  //       .showSnackBar(
                                                  //     const SnackBar(
                                                  //       content: Text(
                                                  //           'You can select up to 3 items only.'),
                                                  //     ),
                                                  //   );
                                                  //   checkboxStates[index] =
                                                  //       false;
                                                  // }
                                                } else {
                                                  checkboxStates[index] = false;
                                                  selectedCount--;
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              detail?.sizeName ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
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
                  Positioned(
                    bottom: 0,
                    left: 5,
                    right: 5,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, -2),
                          ),
                        ],
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        providerService.decrementQuantity();
                                      },
                                    ),
                                    Text(
                                      providerService.quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        providerService.incrementQuantity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ),
                            onPressed: () async {
                              // Filter the selected items
                              final selectedSizes = item.productArray
                                  ?.asMap()
                                  .entries
                                  .where((entry) =>
                                      checkboxStates[entry.key] == true)
                                  .map((entry) => entry.value.proDetailCode)
                                  .toList();

                              // Ensure at least one size is selected
                              if (selectedSizes == null ||
                                  selectedSizes.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('ເລືອກຢ່າງໜ້ອຍ 1 ລາຍການ'),
                                  ),
                                );
                                return;
                              }

                              print(
                                  "result: ${tableCode} / ${MyData.branchCode} / ${selectedSizes}");

                              // await providerService.addCart(
                              //   item.productID,
                              //   providerService.quantity.toString(),
                              //   tableCode,
                              //   selectedSizes,
                              //   textlController.text,
                              // );

                              EasyLoading.show(status: 'loading...');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'ສຳເລັດ',
                                desc: 'ເພີ່ມເຂົ້າກະຕ໋າສຳເລັດ!',
                                btnOkOnPress: () {},
                              ).show();
                              EasyLoading.dismiss();

                              // Reset the quantity to 1
                              providerService.resetQuantity();
                            },
                            child: const Text(
                              'ເພີ່ມເຂົ້າກະຕ໋າ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading product details"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
