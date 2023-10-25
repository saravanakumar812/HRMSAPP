class chooseTemplate {
  String? status;
  String? message;
  List<Data>? list;

  chooseTemplate({this.status, this.message, this.list});

  chooseTemplate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <Data>[];
      json['list'].forEach((v) {
        list!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? catId;
  String? catName;
  String? catNamear;
  String? catImage;
  String? catActive;
  String? catStatus;
  String? updatedAt;
  String? imagePath;

  Data(
      {this.catId,
      this.catName,
      this.catNamear,
      this.catImage,
      this.catActive,
      this.catStatus,
      this.updatedAt,
      this.imagePath});

  Data.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
    catNamear = json['cat_name_ar'];
    catImage = json['cat_image'];
    catActive = json['cat_active'];
    catStatus = json['cat_status'];
    updatedAt = json['updated_at'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    data['cat_name_ar'] = this.catNamear;
    data['cat_image'] = this.catImage;
    data['cat_active'] = this.catActive;
    data['cat_status'] = this.catStatus;
    data['updated_at'] = this.updatedAt;
    data['image_path'] = this.imagePath;
    return data;
  }
}
