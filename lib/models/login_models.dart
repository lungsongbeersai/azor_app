class LoginInfo {
  String? status;
  String? message;
  String? usersId;
  String? usersName;
  String? branchCode;
  String? branchName;
  String? statusCode;
  String? statusName;
  String? cookingStatus;
  String? cookStatusName;
  String? offOn;

  LoginInfo(
      {this.status,
      this.message,
      this.usersId,
      this.usersName,
      this.branchCode,
      this.branchName,
      this.statusCode,
      this.statusName,
      this.cookingStatus,
      this.cookStatusName,
      this.offOn});

  LoginInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    statusCode = json['status_code'];
    statusName = json['status_name'];
    cookingStatus = json['cooking_status'];
    cookStatusName = json['cook_status_name'];
    offOn = json['off_on'];
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
    data['cooking_status'] = this.cookingStatus;
    data['cook_status_name'] = this.cookStatusName;
    data['off_on'] = this.offOn;
    return data;
  }
}
