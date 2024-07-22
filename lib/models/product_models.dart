class ProductListModel {
  String? productPathApi;
  String? productId;
  String? productName;
  String? productCateFk;

  ProductListModel(
      {this.productPathApi,
      this.productId,
      this.productName,
      this.productCateFk});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    productPathApi = json['product_path_api'];
    productId = json['product_id'];
    productName = json['product_name'];
    productCateFk = json['product_cate_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_path_api'] = this.productPathApi;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_cate_fk'] = this.productCateFk;
    return data;
  }
}
