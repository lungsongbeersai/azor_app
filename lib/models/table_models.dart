class TableModel {
  String? tableCode;
  String? tableName;
  String? zoneName;
  String? tableStatus;

  TableModel({this.tableCode, this.tableName, this.zoneName, this.tableStatus});

  TableModel.fromJson(Map<String, dynamic> json) {
    tableCode = json['table_code'];
    tableName = json['table_name'];
    zoneName = json['zone_name'];
    tableStatus = json['table_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_code'] = this.tableCode;
    data['table_name'] = this.tableName;
    data['zone_name'] = this.zoneName;
    data['table_status'] = this.tableStatus;
    return data;
  }
}
