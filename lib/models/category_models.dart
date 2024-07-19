class CategoryModel {
  String? cateCode;
  String? cateName;
  String? cateGroup;

  CategoryModel({this.cateCode, this.cateName, this.cateGroup});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    cateCode = json['cate_code'];
    cateName = json['cate_name'];
    cateGroup = json['cate_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_code'] = this.cateCode;
    data['cate_name'] = this.cateName;
    data['cate_group'] = this.cateGroup;
    return data;
  }
}
