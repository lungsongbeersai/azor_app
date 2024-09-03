class ProductSearch {
  String? productPathApi;
  String? productId;
  String? productName;
  String? productCateFk;
  String? productDiscount;
  String? productSet;

  ProductSearch(
      {this.productPathApi,
      this.productId,
      this.productName,
      this.productCateFk,
      this.productDiscount,
      this.productSet});

  ProductSearch.fromJson(Map<String, dynamic> json) {
    productPathApi = json['product_path_api'];
    productId = json['product_id'];
    productName = json['product_name'];
    productCateFk = json['product_cate_fk'];
    productDiscount = json['product_discount'];
    productSet = json['product_set'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_path_api'] = this.productPathApi;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_cate_fk'] = this.productCateFk;
    data['product_discount'] = this.productDiscount;
    data['product_set'] = this.productSet;
    return data;
  }
}
