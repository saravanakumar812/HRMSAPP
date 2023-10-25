class selectedTemplateModel {
  String? status;
  String? message;
  List<Data>? list;

  selectedTemplateModel({this.status, this.message, this.list});

  selectedTemplateModel.fromJson(Map<String, dynamic> json) {
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
  String? tempId;
  String? tempName;
  String? tempCategory;
  String? tempImage;
  String? tempImagePath;
  String? tempPages;
  String? tempActive;
  String? tempStatus;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.tempId,
      this.tempName,
      this.tempCategory,
      this.tempImage,
      this.tempImagePath,
      this.tempPages,
      this.tempActive,
      this.tempStatus,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    tempId = json['temp_id'];
    tempName = json['temp_name'];
    tempCategory = json['temp_category'];
    tempImage = json['temp_image'];
    tempImagePath = json['temp_image_path'];
    tempPages = json['temp_pages'];
    tempActive = json['temp_active'];
    tempStatus = json['temp_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp_id'] = this.tempId;
    data['temp_name'] = this.tempName;
    data['temp_category'] = this.tempCategory;
    data['temp_image'] = this.tempImage;
    data['temp_image_path'] = this.tempImagePath;
    data['temp_pages'] = this.tempPages;
    data['temp_active'] = this.tempActive;
    data['temp_status'] = this.tempStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
