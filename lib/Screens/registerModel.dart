class registerModel {
  String? status;
  String? message;
  ProfileDetails? profileDetails;
  String? userId;

  registerModel({this.status, this.message, this.profileDetails, this.userId});

  registerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    profileDetails = json['profile_details'] != null
        ? new ProfileDetails.fromJson(json['profile_details'])
        : null;
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.profileDetails != null) {
      data['profile_details'] = this.profileDetails!.toJson();
    }
    data['user_id'] = this.userId;
    return data;
  }
}

class ProfileDetails {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userPassword;
  String? confirmedUserPassword;
  int? userStatus;
  int? userOtp;
  String? createdAt;

  ProfileDetails(
      {this.userName,
        this.userEmail,
        this.userPhone,
        this.userPassword,
        this.confirmedUserPassword,
        this.userStatus,
        this.userOtp,
        this.createdAt});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    userPassword = json['user_password'];
    confirmedUserPassword = json['confirmed_user_password'];
    userStatus = json['user_status'];
    userOtp = json['user_otp'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['user_password'] = this.userPassword;
    data['confirmed_user_password'] = this.confirmedUserPassword;
    data['user_status'] = this.userStatus;
    data['user_otp'] = this.userOtp;
    data['created_at'] = this.createdAt;
    return data;
  }
}

