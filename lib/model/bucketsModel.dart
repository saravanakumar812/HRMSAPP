class bucketsModel {
  String? status;
  String? message;
  List<ListMain>? list;

  bucketsModel({this.status, this.message, this.list});

  bucketsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <ListMain>[];
      json['list'].forEach((v) {
        list!.add(ListMain.fromJson(v));
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

class ListMain {
  String? buckId;
  String? buckName;
  String? buckNamear;
  String? buckInvitations;
  String? buckBuckPrice;
  String? buckTotal;
  String? buckActive;
  String? buckStatus;
  String? createdAt;
  String? updatedAt;

  ListMain(
      {this.buckId,
        this.buckName,
        this.buckNamear,
        this.buckInvitations,
        this.buckBuckPrice,
        this.buckTotal,
        this.buckActive,
        this.buckStatus,
        this.createdAt,
        this.updatedAt});

  ListMain.fromJson(Map<String, dynamic> json) {
    buckId = json['buck_id'];
    buckName = json['buck_name'];
    buckNamear = json['bucket_name_ar'];
    buckInvitations = json['buck_invitations'];
    buckBuckPrice = json['buck_buck_price'];
    buckTotal = json['buck_total'];
    buckActive = json['buck_active'];
    buckStatus = json['buck_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buck_id'] = this.buckId;
    data['buck_name'] = this.buckName;
    data['bucket_name_ar'] = this.buckNamear;
    data['buck_invitations'] = this.buckInvitations;
    data['buck_buck_price'] = this.buckBuckPrice;
    data['buck_total'] = this.buckTotal;
    data['buck_active'] = this.buckActive;
    data['buck_status'] = this.buckStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

