class ChatModel {
  int id;
  int userId;
  String message;
  String reply;
  String createdAt;
  String updatedAt;
  int checked;
  String image;

  ChatModel(
      {this.id,
        this.userId,
        this.message,
        this.reply,
        this.createdAt,
        this.updatedAt,
        this.checked,
        this.image});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    reply = json['reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = json['checked'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['reply'] = this.reply;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['checked'] = this.checked;
    data['image'] = this.image;
    return data;
  }
}
