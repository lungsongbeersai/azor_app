class ProductGetid {
  String? productId;
  String? productName;
  String? productPathApi;
  List<ProductArray>? productArray;

  ProductGetid(
      {this.productId,
      this.productName,
      this.productPathApi,
      this.productArray});

  ProductGetid.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPathApi = json['product_path_api'];
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

  ProductArray(
      {this.proDetailCode,
      this.sizeName,
      this.sPrice,
      this.proDetailGift,
      this.productCutStock,
      this.proDetailQty});

  ProductArray.fromJson(Map<String, dynamic> json) {
    proDetailCode = json['pro_detail_code'];
    sizeName = json['size_name'];
    sPrice = json['s_price'];
    proDetailGift = json['pro_detail_gift'];
    productCutStock = json['product_cut_stock'];
    proDetailQty = json['pro_detail_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_detail_code'] = this.proDetailCode;
    data['size_name'] = this.sizeName;
    data['s_price'] = this.sPrice;
    data['pro_detail_gift'] = this.proDetailGift;
    data['product_cut_stock'] = this.productCutStock;
    data['pro_detail_qty'] = this.proDetailQty;
    return data;
  }
}
