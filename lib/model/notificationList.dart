class notificationList {
  String? status;
  String? message;
  List<ListNotifcations>? list;

  notificationList({this.status, this.message, this.list});

  notificationList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['list'] != null) {
      list = <ListNotifcations>[];
      json['list'].forEach((v) {
        list!.add(new ListNotifcations.fromJson(v));
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

class ListNotifcations {
  String? id;
  String? message;
  String? title;
  String? date;

  ListNotifcations({this.id, this.message, this.title, this.date});

  ListNotifcations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    title = json['title'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['title'] = this.title;
    data['date'] = this.date;
    return data;
  }
}

