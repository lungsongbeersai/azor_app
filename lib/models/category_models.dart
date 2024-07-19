class CategoryModel {
  String? cateCode;
  String? cateName;
  String? cateGroup;
  String? cateIcon;

  CategoryModel({this.cateCode, this.cateName, this.cateGroup, this.cateIcon});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    cateCode = json['cate_code'];
    cateName = json['cate_name'];
    cateGroup = json['cate_group'];
    cateIcon = json['cate_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_code'] = this.cateCode;
    data['cate_name'] = this.cateName;
    data['cate_group'] = this.cateGroup;
    data['cate_icon'] = this.cateIcon;
    return data;
  }
}
