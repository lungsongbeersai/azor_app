import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azor/models/product_getID_set.dart';
import 'package:azor/shared/myData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:azor/services/provider_service.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';

class ProductDetailSet extends StatefulWidget {
  const ProductDetailSet({Key? key}) : super(key: key);

  @override
  _ProductDetailSetState createState() => _ProductDetailSetState();
}

class _ProductDetailSetState extends State<ProductDetailSet> {
  List<bool> checkboxStates = [];
  String proID = '';
  String tableCode = '';
  FocusNode textlFocusNode = FocusNode();
  TextEditingController textlController = TextEditingController();
  int selectedCount = 0;

  List<bool> expandedStates = [];

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
        child: FutureBuilder<List<ProductGetidSet>>(
          future: providerService.getProductIDSet(proID),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final item = snapshot.data!.first;

              if (checkboxStates.length != (item.productArray?.length ?? 0)) {
                checkboxStates =
                    List<bool>.filled(item.productArray?.length ?? 0, false);
                expandedStates =
                    List<bool>.filled(item.productArray?.length ?? 0, false);

                if (item.productArray!.isNotEmpty) expandedStates[0] = true;
                selectedCount = 0;
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
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Center(
                            child: Text(
                              "ລາຄາ ${MyData.formatnumber(item.priceSetSPrice)} ກີບ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
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
                                "ລາຍການເຊັດ",
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

                              final sizeQty =
                                  int.tryParse(detail?.sizeQty ?? '') ?? 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ExpansionTileOutlined(
                                  initiallyExpanded: expandedStates[index],
                                  title: Text(
                                    "${index + 1}. ${detail?.sizeName ?? ''}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  children: [
                                    if (sizeQty > 0)
                                      ListView.builder(
                                        itemCount:
                                            detail?.productSubArray?.length ??
                                                0,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, subIndex) {
                                          final sub = detail
                                              ?.productSubArray?[subIndex];

                                          if (sub == null) {
                                            return SizedBox.shrink();
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (checkboxStates[
                                                          subIndex]) {
                                                        checkboxStates[
                                                            subIndex] = false;
                                                        selectedCount--;
                                                      } else if (selectedCount <
                                                          sizeQty) {
                                                        checkboxStates[
                                                            subIndex] = true;
                                                        selectedCount++;
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                                'ເລືອກໄດ້ບໍ່ເກີນ $sizeQty ລາຍການ'),
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MSHCheckbox(
                                                          size: 30,
                                                          value: checkboxStates[
                                                              subIndex],
                                                          colorConfig:
                                                              MSHColorConfig
                                                                  .fromCheckedUncheckedDisabled(
                                                            checkedColor:
                                                                Colors.blue,
                                                          ),
                                                          style:
                                                              MSHCheckboxStyle
                                                                  .stroke,
                                                          onChanged:
                                                              (selected) {
                                                            setState(() {
                                                              if (selected!) {
                                                                if (selectedCount <
                                                                    sizeQty) {
                                                                  checkboxStates[
                                                                          subIndex] =
                                                                      true;
                                                                  selectedCount++;
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content: Text(
                                                                          'ເລືອກໄດ້ບໍ່ເກີນ $sizeQty ລາຍການ'),
                                                                    ),
                                                                  );
                                                                  checkboxStates[
                                                                          subIndex] =
                                                                      false;
                                                                }
                                                              } else {
                                                                // Uncheck the checkbox and decrement the count
                                                                checkboxStates[
                                                                        subIndex] =
                                                                    false;
                                                                selectedCount--;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Flexible(
                                                          child: Text(
                                                            sub.toppingName ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                  onExpansionChanged: (expanded) {
                                    setState(() {
                                      expandedStates[index] = expanded;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
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
                            offset: const Offset(0, -2),
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
                              List<String> selectedDetails = [];
                              List<String> selectedDetails1 = [];

                              for (int i = 0;
                                  i < (item.productArray?.length ?? 0);
                                  i++) {
                                final detail = item.productArray![i];

                                if (detail.productSubArray != null) {
                                  for (int j = 0;
                                      j < (detail.productSubArray?.length ?? 0);
                                      j++) {
                                    if (j < checkboxStates.length &&
                                        checkboxStates[j]) {
                                      final toppingId =
                                          detail.productSubArray![j].toppingId;
                                      final topname = detail
                                          .productSubArray![j].toppingName;
                                      if (toppingId != null &&
                                          topname != null) {
                                        selectedDetails.add(toppingId);
                                        selectedDetails1.add(topname);
                                      }
                                    }
                                  }
                                }
                              }

                              final proDetailCode =
                                  item.proDetailCode1.toString();
                              final sPrice = item.priceSetSPrice.toString();
                              final quantity = int.parse(
                                  providerService.quantity.toString());
                              int gift = 0;
                              String statusStock = "off";

                              int selectedCount = checkboxStates
                                  .where((checked) => checked)
                                  .length;

                              EasyLoading.show(status: 'loading...');
                              try {
                                if (selectedCount ==
                                    (int.tryParse(
                                            item.productArray![0].sizeQty!) ??
                                        0)) {
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );
                                  final isSuccess =
                                      await providerService.addCart(
                                          tableCode,
                                          MyData.branchCode,
                                          proDetailCode,
                                          sPrice,
                                          quantity,
                                          gift,
                                          statusStock,
                                          selectedDetails1.toString(),
                                          MyData.usersID,
                                          selectedDetails.toString(),
                                          "on");
                                  if (isSuccess) {
                                    if (mounted) {
                                      setState(() {
                                        checkboxStates = List.generate(
                                            checkboxStates.length,
                                            (index) => false);
                                        selectedCount = 0;
                                      });
                                    }
                                    EasyLoading.dismiss();
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: 'ແຈ້ງເຕືອນ',
                                      desc: 'ເພີ່ມເຂົ້າກະຕ໋າສໍາເລັດແລ້ວ!',
                                      btnOkOnPress: () {},
                                    ).show();

                                    providerService.resetQuantity();
                                  }
                                } else {
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );
                                  EasyLoading.dismiss();

                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    headerAnimationLoop: true,
                                    title: 'ແຈ້ງເຕືອນ',
                                    desc:
                                        'ກະລຸນາເລືອກລາຍການໃຫ້ຄົບ ${item.productArray![0].sizeQty} ຢ່າງ!',
                                    btnOkIcon: Icons.cancel,
                                    btnOkColor: Colors.red,
                                    btnOkText: 'ປິດ',
                                  ).show();

                                  return;
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                // print('Error: $e');
                                // Handle the error
                              }
                            },
                            child: const Text(
                              'ເພີ່ມເຂົ້າກະຕ໋າ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
