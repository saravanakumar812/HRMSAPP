class responseModel {
  String? status;
  String? text;
  String? type;

  responseModel({this.status, this.text, this.type});

  responseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}
