class LoginInfo {
  String? status;
  String? message;
  String? usersId;
  String? usersName;
  String? branchCode;
  String? branchName;
  String? statusCode;
  String? statusName;

  LoginInfo(
      {this.status,
      this.message,
      this.usersId,
      this.usersName,
      this.branchCode,
      this.branchName,
      this.statusCode,
      this.statusName});

  LoginInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    statusCode = json['status_code'];
    statusName = json['status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['users_id'] = this.usersId;
    data['users_name'] = this.usersName;
    data['branch_code'] = this.branchCode;
    data['branch_name'] = this.branchName;
    data['status_code'] = this.statusCode;
    data['status_name'] = this.statusName;
    return data;
  }
}
