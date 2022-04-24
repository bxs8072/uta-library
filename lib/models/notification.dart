class Notification {
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic> data;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "data": data,
      };

  factory Notification.fromJson(dynamic jsonData) {
    return Notification(
        id: jsonData["id"],
        title: jsonData["title"],
        body: jsonData["body"],
        data: jsonData["data"]);
  }
}
