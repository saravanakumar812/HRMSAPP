class profileDetails {
  String? status;
  String? message;
  UserData? userData;
  int? invCount;

  profileDetails({this.status, this.message, this.userData, this.invCount});

  profileDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
    // invCount = json['inv_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    // data['inv_count'] = this.invCount;
    return data;
  }
}

class UserData {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userCompany;
  String? userAddress;
  String? userCountry;
  String? userState;
  String? userCity;
  String? userZip;
  String? userImage;
  String? dispStatus;
  String? imagePath;

  UserData(
      {this.userId,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.userCompany,
      this.userAddress,
      this.userCountry,
      this.userState,
      this.userCity,
      this.userZip,
      this.userImage,
      this.dispStatus,
      this.imagePath});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    userCompany = json['user_company'];
    userAddress = json['user_address'];
    userCountry = json['user_country'];
    userState = json['user_state'];
    userCity = json['user_city'];
    userZip = json['user_zip'];
    userImage = json['user_image'];
    dispStatus = json['disp_status'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['user_company'] = this.userCompany;
    data['user_address'] = this.userAddress;
    data['user_country'] = this.userCountry;
    data['user_state'] = this.userState;
    data['user_city'] = this.userCity;
    data['user_zip'] = this.userZip;
    data['user_image'] = this.userImage;
    data['disp_status'] = this.dispStatus;
    data['image_path'] = this.imagePath;
    return data;
  }
}
