class invitationModel {
  String? status;
  String? message;
  List<Invitation>? list;

  invitationModel({this.status, this.message, this.list});

  invitationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <Invitation>[];
      json['list'].forEach((v) {
        list!.add(new Invitation.fromJson(v));
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

class Invitation {
  String? coordinator_name;
  String? coordinator_mobile;
  String? image;
  String? invId;
  String? invPartyname;
  String? invname;
  String? invDate;
  String? invTime;
  String? invLocationlink;
  String? invLocation;
  String? invEmail;
  String? invMobile;
  String? invTempcategory;
  String? invTemplate;
  String? invTempImg;
  String? invBucket;
  String? latitude;
  String? longitude;
  String? userId;
  String? noOfInvitations;
  String? enrolled;
  String? transationId;
  String? cost;
  String? createdAt;
  Bucket? bucket;
  Category? category;
  Template? template;
  String? sendTotal;
  String? sendAccept;
  String? sendPending;
  String? sendCanceled;

  Invitation(
      {this.invId,
        this.invPartyname,
        this.image,
        this.coordinator_name,
        this.coordinator_mobile,
        this.invname,
        this.invDate,
        this.invTime,
        this.invLocationlink,
        this.invLocation,
        this.invEmail,
        this.invMobile,
        this.invTempcategory,
        this.invTemplate,
        this.invTempImg,
        this.invBucket,
        this.latitude,
        this.longitude,
        this.userId,
        this.noOfInvitations,
        this.enrolled,
        this.transationId,
        this.cost,
        this.createdAt,
        this.bucket,
        this.category,
        this.template,
        this.sendTotal,
        this.sendAccept,
        this.sendPending,
        this.sendCanceled});

  Invitation.fromJson(Map<String, dynamic> json) {
    invId = json['inv_id'];
    invPartyname = json['inv_partyname'];
    coordinator_name = json['coordinator_name'];
    coordinator_mobile = json['coordinator_mobile'];
    image = json['image'];
    invname = json['inv_name'];
    invDate = json['inv_date'];
    invTime = json['inv_time'];
    invLocationlink = json['inv_locationlink'];
    invLocation = json['inv_location'];
    invEmail = json['inv_email'];
    invMobile = json['inv_mobile'];
    invTempcategory = json['inv_tempcategory'];
    invTemplate = json['inv_template'];
    invTempImg = json['inv_tempImg'];
    invBucket = json['inv_bucket'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userId = json['user_id'];
    noOfInvitations = json['wallet_count'];
    enrolled = json['enrolled'];
    transationId = json['transation_id'];
    cost = json['cost'];
    createdAt = json['created_at'];
    bucket =
    json['bucket'] != null ? new Bucket.fromJson(json['bucket']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    template = json['template'] != null
        ? new Template.fromJson(json['template'])
        : null;
    sendTotal = json['send_total'];
    sendAccept = json['send_accept'];
    sendPending = json['send_pending'];
    sendCanceled = json['send_canceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_id'] = this.invId;
    data['coordinator_name'] = this.coordinator_name;
    data['coordinator_mobile'] = this.coordinator_mobile;
    data['image'] = this.image;
    data['inv_partyname'] = this.invPartyname;
    data['inv_name'] = this.invname;
    data['inv_date'] = this.invDate;
    data['inv_time'] = this.invTime;
    data['inv_locationlink'] = this.invLocationlink;
    data['inv_location'] = this.invLocation;
    data['inv_email'] = this.invEmail;
    data['inv_mobile'] = this.invMobile;
    data['inv_tempcategory'] = this.invTempcategory;
    data['inv_template'] = this.invTemplate;
    data['inv_tempImg'] = this.invTempImg;
    data['inv_bucket'] = this.invBucket;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['user_id'] = this.userId;
    data['no_of_invitations'] = this.noOfInvitations;
    data['enrolled'] = this.enrolled;
    data['transation_id'] = this.transationId;
    data['cost'] = this.cost;
    data['created_at'] = this.createdAt;
    if (this.bucket != null) {
      data['bucket'] = this.bucket!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.template != null) {
      data['template'] = this.template!.toJson();
    }
    data['send_total'] = this.sendTotal;
    data['send_accept'] = this.sendAccept;
    data['send_pending'] = this.sendPending;
    data['send_canceled'] = this.sendCanceled;
    return data;
  }
}

class Bucket {
  String? buckId;
  String? buckName;
  String? buckInvitations;
  String? buckBuckPrice;
  String? buckTotal;
  String? buckActive;
  String? buckStatus;
  String? createdAt;
  String? updatedAt;

  Bucket(
      {this.buckId,
        this.buckName,
        this.buckInvitations,
        this.buckBuckPrice,
        this.buckTotal,
        this.buckActive,
        this.buckStatus,
        this.createdAt,
        this.updatedAt});

  Bucket.fromJson(Map<String, dynamic> json) {
    buckId = json['buck_id'];
    buckName = json['buck_name'];
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

class Category {
  String? catId;
  String? catName;
  String? catImage;
  String? catActive;
  String? catStatus;
  String? updatedAt;
  String? imagePath;

  Category(
      {this.catId,
        this.catName,
        this.catImage,
        this.catActive,
        this.catStatus,
        this.updatedAt,
        this.imagePath});

  Category.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
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
    data['cat_image'] = this.catImage;
    data['cat_active'] = this.catActive;
    data['cat_status'] = this.catStatus;
    data['updated_at'] = this.updatedAt;
    data['image_path'] = this.imagePath;
    return data;
  }
}

class Template {
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

  Template(
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

  Template.fromJson(Map<String, dynamic> json) {
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

