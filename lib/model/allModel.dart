class allModel {
  String? status;
  String? message;
  List<All>? list;

  allModel({this.status, this.message, this.list});

  allModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <All>[];
      json['list'].forEach((v) {
        list!.add(new All.fromJson(v));
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

class All {
  String? user_id;
  String? user_name;
  String? phone_number;


  All(
      {this.user_id,
        this.user_name,
        this.phone_number,
       });

  All.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    user_name = json['user_name'];
    phone_number = json['phone_number'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['user_name'] = this.user_name;
    data['phone_number'] = this.phone_number;

    return data;
  }
}


