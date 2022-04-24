import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uta_library/models/booking.dart';

// Get list of all the slots in 30 minutes interval from 12 am to 12 am for provided date
List<Booked> bookedList(Timestamp timestamp) {
  int year = timestamp.toDate().year;
  int month = timestamp.toDate().month;
  int day = timestamp.toDate().day;
  List<Booked> _list = [
    Booked(
      id: 0,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 0, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 0, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 1,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 0, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 1, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 2,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 1, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 1, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 3,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 1, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 2, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 4,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 2, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 2, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 5,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 2, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 3, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 6,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 3, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 3, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 7,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 3, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 4, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 8,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 4, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 4, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 9,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 4, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 5, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 10,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 5, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 5, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 11,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 5, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 6, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 12,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 6, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 6, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 13,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 6, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 7, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 14,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 7, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 7, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 15,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 7, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 8, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 16,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 8, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 8, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 17,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 8, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 9, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 18,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 9, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 9, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 19,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 9, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 10, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 20,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 10, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 10, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 21,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 10, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 11, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 22,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 11, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 11, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 23,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 11, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 12, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 24,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 12, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 12, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 25,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 12, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 13, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 26,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 13, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 13, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 27,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 13, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 14, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 28,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 14, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 14, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 39,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 14, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 15, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 30,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 15, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 15, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 31,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 15, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 16, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 32,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 16, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 16, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 33,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 16, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 17, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 34,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 17, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 17, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 35,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 17, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 18, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 36,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 18, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 18, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 37,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 18, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 19, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 38,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 19, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 19, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 39,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 19, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 20, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 40,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 20, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 20, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 41,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 20, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 21, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 42,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 21, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 21, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 43,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 21, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 22, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 44,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 22, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 22, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 45,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 22, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 23, 0, 0, 0, 0),
      ),
    ),
    Booked(
      id: 46,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 23, 0, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 23, 30, 0, 0, 0),
      ),
    ),
    Booked(
      id: 47,
      startTime: Timestamp.fromDate(
        DateTime(year, month, day, 23, 30, 0, 0, 0),
      ),
      endTime: Timestamp.fromDate(
        DateTime(year, month, day, 0, 0, 0, 0, 0),
      ),
    ),
  ];

  return _list.where((element) {
    if (element.startTime.toDate().day == DateTime.now().day) {
      if (element.startTime.toDate().hour == DateTime.now().hour) {
        return element.startTime.toDate().minute > DateTime.now().minute;
      } else {
        return element.startTime.toDate().hour > DateTime.now().hour;
      }
    } else {
      return true;
    }
  }).toList();
}
