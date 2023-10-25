class forgotpasswordModel {
  String? status;
  int? otp;
  String? message;
  String? userId;
  String? phone_number;

  forgotpasswordModel({this.status, this.otp, this.message,this.userId,this.phone_number});

  forgotpasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    message = json['message'];
    userId = json['user_id'];
    phone_number = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['phone_number'] = this.phone_number;
    return data;
  }
}

