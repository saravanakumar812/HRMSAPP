class loginModel {
  String? status;
  String? userId;
  String? inv_link;
  String? message;
  String? otp;
  String? mobile;

  loginModel({this.status, this.userId, this.message});

  loginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    message = json['message'];
    inv_link = json['inv_link'];
    otp = json['otp'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['inv_link'] = this.inv_link;
    data['otp'] = this.otp;
    data['mobile'] = this.mobile;
    return data;
  }
}
