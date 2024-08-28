class CartModels {
  String? orderListCode;
  String? orderListProCodeFk;
  String? productPathApi;
  String? fullName;
  String? orderListPrice;
  int? orderListQty;
  int? orderListQ;
  String? orderListAmount;
  int? orderListPercented;
  String? orderListTotal;
  String? usersName;
  String? orderListStatusCook;
  int? orderListStatusOrder;
  String? orderListNoteRemark;
  String? proDetailCookingStatus;

  CartModels(
      {this.orderListCode,
      this.orderListProCodeFk,
      this.productPathApi,
      this.fullName,
      this.orderListPrice,
      this.orderListQty,
      this.orderListQ,
      this.orderListAmount,
      this.orderListPercented,
      this.orderListTotal,
      this.usersName,
      this.orderListStatusCook,
      this.orderListStatusOrder,
      this.orderListNoteRemark,
      this.proDetailCookingStatus});

  CartModels.fromJson(Map<String, dynamic> json) {
    orderListCode = json['order_list_code'];
    orderListProCodeFk = json['order_list_pro_code_fk'];
    productPathApi = json['product_path_api'];
    fullName = json['full_name'];
    orderListPrice = json['order_list_price'];
    orderListQty = json['order_list_qty'];
    orderListQ = json['order_list_q'];
    orderListAmount = json['order_list_amount'];
    orderListPercented = json['order_list_percented'];
    orderListTotal = json['order_list_total'];
    usersName = json['users_name'];
    orderListStatusCook = json['order_list_status_cook'];
    orderListStatusOrder = json['order_list_status_order'];
    orderListNoteRemark = json['order_list_note_remark'];
    proDetailCookingStatus = json['pro_detail_cooking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_list_code'] = this.orderListCode;
    data['order_list_pro_code_fk'] = this.orderListProCodeFk;
    data['product_path_api'] = this.productPathApi;
    data['full_name'] = this.fullName;
    data['order_list_price'] = this.orderListPrice;
    data['order_list_qty'] = this.orderListQty;
    data['order_list_q'] = this.orderListQ;
    data['order_list_amount'] = this.orderListAmount;
    data['order_list_percented'] = this.orderListPercented;
    data['order_list_total'] = this.orderListTotal;
    data['users_name'] = this.usersName;
    data['order_list_status_cook'] = this.orderListStatusCook;
    data['order_list_status_order'] = this.orderListStatusOrder;
    data['order_list_note_remark'] = this.orderListNoteRemark;
    data['pro_detail_cooking_status'] = this.proDetailCookingStatus;
    return data;
  }
}
