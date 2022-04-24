import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/models/booking.dart';
import 'package:uta_library/models/notification.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get notificationPlugin => _flutterLocalNotificationsPlugin;

  Future<void> displayNotifications(
      {required Notification notification}) async {
    AndroidNotificationDetails _androidNotificationDetails =
        const AndroidNotificationDetails("uta_library", "uta_library",
            importance: Importance.max, priority: Priority.high);

    NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
    );

    // Show Notifications
    await _flutterLocalNotificationsPlugin.show(
      notification.id.toInt(),
      notification.title,
      notification.body,
      _notificationDetails,
      payload: json.encode(notification.data),
    );
  }

  scheduledNotificaiton(
      {required Notification notification, required Booking booking}) async {
    AndroidNotificationDetails _androidNotificationDetails =
        const AndroidNotificationDetails("uta_library", "uta_library",
            importance: Importance.high, priority: Priority.high);
    NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
    );

    // Schedule the notifications according to the timezone of user
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id.toInt(),
      notification.title,
      notification.body,
      _convertDate(booking: booking),
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: json.encode(notification.data),
    );
  }

  // fetch Booked Data and Schedule the Notifications
  fetchData({
    required User user,
  }) async {
    FirebaseFirestore.instance
        .collection("RoomBookings")
        .where(
          "booked.userId",
          isEqualTo: user.uid,
        )
        .get()
        .then((querySnapshot) {
      final List<Booking> _bookings = querySnapshot.docs
          .map((e) => Booking.fromDocumentSnapshot(e))
          .toList();
      // ignore: avoid_function_literals_in_foreach_calls
      _bookings.forEach((booking) async {
        DocumentSnapshot<Map<String, dynamic>> roomDoc = await FirebaseFirestore
            .instance
            .collection("Rooms")
            .doc(booking.roomId.toString())
            .get();

        Room room = Room.fromDocumentSnapshot(roomDoc);

        Notification _notification = Notification(
          id: _bookings.indexOf(booking),
          title: "Room booked at " + room.location,
          body: Intl()
                  .date("MM/dd/yyyy")
                  .format(booking.booked!.startTime.toDate()) +
              " at " +
              Intl().date("hh:mm a").format(booking.booked!.startTime.toDate()),
          data: {
            "selectedDate": booking.date.toDate().toString(),
            "room": room.toJson(),
            "user": user.toJson(),
          },
        );
        scheduledNotificaiton(
          notification: _notification,
          booking: booking,
        );
      });
    });
  }

  tz.TZDateTime _convertDate({required Booking booking}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        booking.date.toDate().year,
        booking.date.toDate().month,
        booking.date.toDate().day,
        booking.booked!.startTime.toDate().hour,
        booking.booked!.startTime.toDate().minute - 14);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
