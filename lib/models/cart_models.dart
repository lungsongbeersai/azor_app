class CartModels {
  String? orderListCode;
  String? orderListProCodeFk;
  String? productPathApi;
  String? fullName;
  String? orderListPrice;
  int? orderListQty;
  String? orderListAmount;
  int? orderListPercented;
  String? orderListTotal;

  CartModels(
      {this.orderListCode,
      this.orderListProCodeFk,
      this.productPathApi,
      this.fullName,
      this.orderListPrice,
      this.orderListQty,
      this.orderListAmount,
      this.orderListPercented,
      this.orderListTotal});

  CartModels.fromJson(Map<String, dynamic> json) {
    orderListCode = json['order_list_code'];
    orderListProCodeFk = json['order_list_pro_code_fk'];
    productPathApi = json['product_path_api'];
    fullName = json['full_name'];
    orderListPrice = json['order_list_price'];
    orderListQty = json['order_list_qty'];
    orderListAmount = json['order_list_amount'];
    orderListPercented = json['order_list_percented'];
    orderListTotal = json['order_list_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_list_code'] = this.orderListCode;
    data['order_list_pro_code_fk'] = this.orderListProCodeFk;
    data['product_path_api'] = this.productPathApi;
    data['full_name'] = this.fullName;
    data['order_list_price'] = this.orderListPrice;
    data['order_list_qty'] = this.orderListQty;
    data['order_list_amount'] = this.orderListAmount;
    data['order_list_percented'] = this.orderListPercented;
    data['order_list_total'] = this.orderListTotal;
    return data;
  }
}
