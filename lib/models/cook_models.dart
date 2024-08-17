class CooksModel {
  String? orderListCode;
  String? orderListProCodeFk;
  String? orderListTableFk;
  String? orderListBranchFk;
  int? orderListQ;
  String? orderListDateTime;
  String? productPathApi;
  String? fullName;
  String? fullName1;
  String? orderListPrice;
  int? orderListQty;
  String? orderListAmount;
  int? orderListPercented;
  String? orderListTotal;
  int? orderListStatusOrder;
  String? usersName;
  String? orderListStatusCook;
  String? orderListNoteRemark;
  String? proDetailCookingStatus;
  String? tableName;

  CooksModel(
      {this.orderListCode,
      this.orderListProCodeFk,
      this.orderListTableFk,
      this.orderListBranchFk,
      this.orderListQ,
      this.orderListDateTime,
      this.productPathApi,
      this.fullName,
      this.fullName1,
      this.orderListPrice,
      this.orderListQty,
      this.orderListAmount,
      this.orderListPercented,
      this.orderListTotal,
      this.orderListStatusOrder,
      this.usersName,
      this.orderListStatusCook,
      this.orderListNoteRemark,
      this.proDetailCookingStatus,
      this.tableName});

  CooksModel.fromJson(Map<String, dynamic> json) {
    orderListCode = json['order_list_code'];
    orderListProCodeFk = json['order_list_pro_code_fk'];
    orderListTableFk = json['order_list_table_fk'];
    orderListBranchFk = json['order_list_branch_fk'];
    orderListQ = json['order_list_q'];
    orderListDateTime = json['order_list_date_time'];
    productPathApi = json['product_path_api'];
    fullName = json['full_name'];
    fullName1 = json['full_name1'];
    orderListPrice = json['order_list_price'];
    orderListQty = json['order_list_qty'];
    orderListAmount = json['order_list_amount'];
    orderListPercented = json['order_list_percented'];
    orderListTotal = json['order_list_total'];
    orderListStatusOrder = json['order_list_status_order'];
    usersName = json['users_name'];
    orderListStatusCook = json['order_list_status_cook'];
    orderListNoteRemark = json['order_list_note_remark'];
    proDetailCookingStatus = json['pro_detail_cooking_status'];
    tableName = json['table_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_list_code'] = this.orderListCode;
    data['order_list_pro_code_fk'] = this.orderListProCodeFk;
    data['order_list_table_fk'] = this.orderListTableFk;
    data['order_list_branch_fk'] = this.orderListBranchFk;
    data['order_list_q'] = this.orderListQ;
    data['order_list_date_time'] = this.orderListDateTime;
    data['product_path_api'] = this.productPathApi;
    data['full_name'] = this.fullName;
    data['full_name1'] = this.fullName1;
    data['order_list_price'] = this.orderListPrice;
    data['order_list_qty'] = this.orderListQty;
    data['order_list_amount'] = this.orderListAmount;
    data['order_list_percented'] = this.orderListPercented;
    data['order_list_total'] = this.orderListTotal;
    data['order_list_status_order'] = this.orderListStatusOrder;
    data['users_name'] = this.usersName;
    data['order_list_status_cook'] = this.orderListStatusCook;
    data['order_list_note_remark'] = this.orderListNoteRemark;
    data['pro_detail_cooking_status'] = this.proDetailCookingStatus;
    data['table_name'] = this.tableName;
    return data;
  }
}
