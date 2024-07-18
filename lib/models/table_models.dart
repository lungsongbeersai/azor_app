class TableModel {
  String? tableCode;
  String? tableName;
  String? zoneName;

  TableModel({this.tableCode, this.tableName, this.zoneName});

  TableModel.fromJson(Map<String, dynamic> json) {
    tableCode = json['table_code'];
    tableName = json['table_name'];
    zoneName = json['zone_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_code'] = this.tableCode;
    data['table_name'] = this.tableName;
    data['zone_name'] = this.zoneName;
    return data;
  }
}
