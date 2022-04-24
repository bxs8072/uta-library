import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final Timestamp date;
  final Booked? booked;
  final int roomId;

  Booking({
    required this.date,
    required this.booked,
    required this.roomId,
  });

  // Convert Booking class Model to JSON object
  Map<String, dynamic> toJson() => {
        "date": date,
        "booked": booked!.toJson(),
        "roomId": roomId,
      };

  // Convert JSON object type to the Booking class Model
  factory Booking.fromJson(dynamic jsonData) => Booking(
        date: jsonData["date"],
        booked: Booked.fromJson(jsonData["booked"]),
        roomId: jsonData["roomId"],
      );

  // Convert DocumentSnapshot object type to the Booking class Model
  factory Booking.fromDocumentSnapshot(DocumentSnapshot data) => Booking(
        date: data["date"],
        booked: Booked.fromJson(data["booked"]),
        roomId: data["roomId"],
      );
}

class Booked {
  final int id;
  final Timestamp startTime, endTime;
  final String? userId;
  Booked({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.userId,
  });

  // Convert Booked class Model to JSON object
  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime,
        "endTime": endTime,
        "userId": userId,
      };

  // Convert JSON object type to the Booked class Model
  factory Booked.fromJson(dynamic jsonData) => Booked(
        id: jsonData["id"],
        startTime: jsonData["startTime"],
        endTime: jsonData["endTime"],
        userId: jsonData["userId"],
      );
}
