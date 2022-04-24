import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final int id;
  final String room, location, features;
  final int capacity;

  Room({
    required this.id,
    required this.room,
    required this.location,
    required this.features,
    required this.capacity,
  });

  // Convert Room class Model to JSON object
  Map<String, dynamic> toJson() => {
        "id": id,
        "room": room,
        "location": location,
        "features": features,
        "capacity": capacity,
      };

  // Convert JSON object type to the Room class Model
  factory Room.fromJson(dynamic jsonData) => Room(
      id: jsonData["id"],
      room: jsonData["room"],
      location: jsonData["location"],
      features: jsonData["features"],
      capacity: jsonData["capacity"]);

  // Convert DocumentSnapshot object type to the Room class Model
  factory Room.fromDocumentSnapshot(DocumentSnapshot jsonData) => Room(
      id: jsonData["id"],
      room: jsonData["room"],
      location: jsonData["location"],
      features: jsonData["features"],
      capacity: jsonData["capacity"]);
}
