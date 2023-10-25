class transactionsModel {
  String? status;
  String? message;
  List<ListTrans>? list;

  transactionsModel({this.status, this.message, this.list});

  transactionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <ListTrans>[];
      json['list'].forEach((v) {
        list!.add(new ListTrans.fromJson(v));
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

class ListTrans {
  String? invId;
  String? userId;
  String? transactionId;
  String? cost;
  String? createdAt;

  ListTrans(
      {this.invId, this.userId, this.transactionId, this.cost, this.createdAt});

  ListTrans.fromJson(Map<String, dynamic> json) {
    invId = json['inv_id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    cost = json['cost'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_id'] = this.invId;
    data['user_id'] = this.userId;
    data['transaction_id'] = this.transactionId;
    data['cost'] = this.cost;
    data['created_at'] = this.createdAt;
    return data;
  }
}

