import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/models/booking.dart';
import 'package:uta_library/models/notification.dart' as notification;
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/notification_service.dart';
//import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';
import 'package:uta_library/uis/room_detail_ui/time_range.dart';

class RoomBookingRepository {
  final User user;
  final Room room;
  final DateTime selectedDate;
  final List<Booked>? initBookedList;

  RoomBookingRepository({
    required this.user,
    required this.room,
    required this.selectedDate,
    this.initBookedList,
  });

  static const String roomBookingCollection = "RoomBookings";

  Stream<QuerySnapshot> get stream => FirebaseFirestore.instance
      .collection(roomBookingCollection)
      .where("roomId", isEqualTo: room.id)
      .where(
        "date",
        isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)),
      )
      .snapshots();

  List<Booked> _bookedList = [];

  List<Booked> get getBookedList =>
      initBookedList == null ? _bookedList : initBookedList!;

  void setBookedList() {
    _bookedList = bookedList(Timestamp.fromDate(selectedDate));
  }

  void updateBookedList(List<Booking> bookings) {
    for (int i = 0; i < _bookedList.length; i++) {
      // ignore: avoid_function_literals_in_foreach_calls
      bookings.forEach((booking) {
        // If slot is already booked then replace the original slots with booked slots
        if (booking.booked!.startTime == _bookedList[i].startTime) {
          _bookedList[i] = booking.booked!;
        }
      });
    }
  }

  Color availableColor(int i) =>
      _bookedList[i].userId == null ? Colors.green : Colors.red;

  String getTime(
          int i) => //Formating utc date into specific format for time only
      Intl().date("h:mm a").format(getBookedList[i].startTime.toDate()) +
      " - " +
      Intl().date("h:mm a").format(getBookedList[i].endTime.toDate());

  String getDate(int i) => Intl().date("MM/dd/yyyy").format(selectedDate);

  Future<bool> isDailyLimitReached(int i) async {
    QuerySnapshot<Map<String, dynamic>> queryDoc =
        await FirebaseFirestore.instance
            .collection(roomBookingCollection)
            .where('booked.userId', isEqualTo: user.uid)
            .where(
              "date",
              isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)),
            )
            .get();

    return queryDoc.docs.length >= 6;
  }

  Future<bool> isTimeConflict(Timestamp startDate) async {
    QuerySnapshot<Map<String, dynamic>> queryDoc =
        await FirebaseFirestore.instance
            .collection(roomBookingCollection)
            .where('booked.userId', isEqualTo: user.uid)
            .where(
              "booked.startTime",
              isEqualTo: startDate,
            )
            .get();

    return queryDoc.docs.isNotEmpty;
  }

  bool isRoomAvailable(int i) {
    return _bookedList[i].userId == null;
  }

  Future<void> addBooking(int i) async {
    FirebaseFirestore.instance
        .collection("RoomBookings")
        .doc()
        .set(
          Booking(
                  date: Timestamp.fromDate(selectedDate),
                  booked: Booked(
                    id: getBookedList[i].id,
                    userId: user.uid,
                    startTime: getBookedList[i].startTime,
                    endTime: getBookedList[i].endTime,
                  ),
                  roomId: room.id)
              .toJson(),
        )
        .then((value) {
      NotificationService.instance.displayNotifications(
        notification: notification.Notification(
            title: "Room booked at " + room.location,
            body: Intl()
                    .date("MM/dd/yyyy")
                    .format(getBookedList[i].startTime.toDate()) +
                " at " +
                Intl()
                    .date("hh:mm a")
                    .format(getBookedList[i].startTime.toDate()),
            data: {
              "selectedDate": selectedDate.toString(),
              "room": room.toJson(),
              "user": user.toJson(),
            },
            id: i),
      );
    });
  }

  Future<void> deleteBooking(int i) async {
    await FirebaseFirestore.instance
        .collection(roomBookingCollection)
        .where("roomId", isEqualTo: room.id)
        .where(
          "date",
          isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)),
        )
        .where("booked.startTime", isEqualTo: getBookedList[i].startTime)
        .get()
        .then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        //slot can be removed fro booked list if it was booked by same user
        element.reference.delete();
      });
    });
  }
}
