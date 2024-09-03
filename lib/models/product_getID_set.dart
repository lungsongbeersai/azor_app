class ProductGetidSet {
  String? productId;
  String? productName;
  String? productPathApi;
  String? priceSetSPrice;
  String? proDetailCode1;
  List<ProductArray>? productArray;

  ProductGetidSet(
      {this.productId,
      this.productName,
      this.productPathApi,
      this.priceSetSPrice,
      this.proDetailCode1,
      this.productArray});

  ProductGetidSet.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPathApi = json['product_path_api'];
    priceSetSPrice = json['price_set_s_price'];
    proDetailCode1 = json['pro_detail_code1'];
    if (json['product_array'] != null) {
      productArray = <ProductArray>[];
      json['product_array'].forEach((v) {
        productArray!.add(new ProductArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_path_api'] = this.productPathApi;
    data['price_set_s_price'] = this.priceSetSPrice;
    data['pro_detail_code1'] = this.proDetailCode1;
    if (this.productArray != null) {
      data['product_array'] =
          this.productArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductArray {
  String? proDetailCode;
  String? sizeName;
  int? sPrice;
  int? proDetailGift;
  String? productCutStock;
  int? proDetailQty;
  String? sizeQty;
  List<ProductSubArray>? productSubArray;

  ProductArray(
      {this.proDetailCode,
      this.sizeName,
      this.sPrice,
      this.proDetailGift,
      this.productCutStock,
      this.proDetailQty,
      this.sizeQty,
      this.productSubArray});

  ProductArray.fromJson(Map<String, dynamic> json) {
    proDetailCode = json['pro_detail_code'];
    sizeName = json['size_name'];
    sPrice = json['s_price'];
    proDetailGift = json['pro_detail_gift'];
    productCutStock = json['product_cut_stock'];
    proDetailQty = json['pro_detail_qty'];
    sizeQty = json['size_qty'];
    if (json['product_sub_array'] != null) {
      productSubArray = <ProductSubArray>[];
      json['product_sub_array'].forEach((v) {
        productSubArray!.add(new ProductSubArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_detail_code'] = this.proDetailCode;
    data['size_name'] = this.sizeName;
    data['s_price'] = this.sPrice;
    data['pro_detail_gift'] = this.proDetailGift;
    data['product_cut_stock'] = this.productCutStock;
    data['pro_detail_qty'] = this.proDetailQty;
    data['size_qty'] = this.sizeQty;
    if (this.productSubArray != null) {
      data['product_sub_array'] =
          this.productSubArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSubArray {
  String? toppingId;
  String? toppingName;

  ProductSubArray({this.toppingId, this.toppingName});

  ProductSubArray.fromJson(Map<String, dynamic> json) {
    toppingId = json['topping_id'];
    toppingName = json['topping_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topping_id'] = this.toppingId;
    data['topping_name'] = this.toppingName;
    return data;
  }
}
