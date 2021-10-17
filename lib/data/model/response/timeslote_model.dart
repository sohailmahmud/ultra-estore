class TimeSlotModel {
  int id;
  String startTime;
  String endTime;
  String date;
  int status;
  String createdAt;
  String updatedAt;

  TimeSlotModel(
      {this.id,
        this.startTime,
        this.endTime,
        this.date,
        this.status,
        this.createdAt,
        this.updatedAt});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['date'] = this.date;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
