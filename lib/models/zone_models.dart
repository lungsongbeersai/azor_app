class ZoneModel {
  String? zoneCode;
  String? zoneBranchFk;
  String? zoneName;

  ZoneModel({this.zoneCode, this.zoneBranchFk, this.zoneName});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    zoneCode = json['zone_code'];
    zoneBranchFk = json['zone_branch_fk'];
    zoneName = json['zone_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone_code'] = this.zoneCode;
    data['zone_branch_fk'] = this.zoneBranchFk;
    data['zone_name'] = this.zoneName;
    return data;
  }
}
