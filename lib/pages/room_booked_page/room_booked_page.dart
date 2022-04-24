import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uta_library/models/booking.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/pages/room_booked_page/room_booked_page_appbar.dart';
import 'package:uta_library/tools/app_drawer/app_drawer.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/room_detail_ui/components/schedule_builder/room_booking_repository.dart';
import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';

class RoomBookedPage extends StatefulWidget {
  final User user;
  final bool canPop;
  const RoomBookedPage({Key? key, required this.user, required this.canPop})
      : super(key: key);

  @override
  State<RoomBookedPage> createState() => _RoomBookedPageState();
}

class _RoomBookedPageState extends State<RoomBookedPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(user: widget.user),
      body: CustomScrollView(
        slivers: [
          RoomBookedPageAppBar(
            canPop: widget.canPop,
            user: widget.user,
            key: widget.key,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("RoomBookings")
                  .where("booked.userId", isEqualTo: widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Text("Loading"),
                  );
                }

                List<Booking> _bookingList = snapshot.data!.docs
                    .map((e) => Booking.fromDocumentSnapshot(e))
                    .toList();
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TableCalendar<Booking>(
                        focusedDay: _focusedDay,
                        firstDay: DateTime.now(),
                        lastDay: DateTime(
                          DateTime.now().year + 1,
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        calendarFormat: _calendarFormat,
                        calendarStyle: CalendarStyle(
                          canMarkersOverflow: false,
                          isTodayHighlighted: true,
                          todayDecoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: ThemeTools.appBarForeGroundColor(context),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        currentDay: DateTime.now(),
                        eventLoader: (a) {
                          //Add events to the day where slot is booked for current user
                          final kEvents =
                              LinkedHashMap<DateTime, List<Booking>>(
                            equals: isSameDay,
                          )..addAll({
                                  a: _bookingList
                                      .where(
                                          (e) => isSameDay(a, e.date.toDate()))
                                      .toList(),
                                });

                          return kEvents[a] ?? [];
                        },
                      ),
                    ],
                  ),
                );
              }),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                "Activities",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: customSize(context).height * 0.023,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("RoomBookings")
                  .where("booked.userId", isEqualTo: widget.user.uid)
                  .where(
                    "date",
                    isEqualTo:
                        Timestamp.fromDate(DateUtils.dateOnly(_selectedDate)),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No Room has been booked...",
                        style: GoogleFonts.lato(
                          fontSize: customSize(context).height * 0.02,
                        ),
                      ),
                    ),
                  );
                }

                List<Booking> _bookingList = snapshot.data!.docs
                    .map((e) => Booking.fromDocumentSnapshot(e))
                    .toList();
                List<Booked> _bookedList =
                    _bookingList.map((e) => e.booked!).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Card(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Rooms")
                            .doc(_bookingList[i].roomId.toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center();
                          }

                          Room _room =
                              Room.fromDocumentSnapshot(snapshot.data!);

                          RoomBookingRepository _repos = RoomBookingRepository(
                            user: widget.user,
                            room: _room,
                            selectedDate: _selectedDate,
                            initBookedList: _bookedList,
                          );
                          return ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                Platform.isIOS
                                    ? showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (ctx) => CupertinoAlertDialog(
                                          title: Text(
                                            "Are you sure?",
                                            style: GoogleFonts.lato(
                                              letterSpacing: 1.5,
                                              color: ThemeTools.primaryColor,
                                              fontSize:
                                                  customSize(context).height *
                                                      0.018,
                                            ),
                                          ),
                                          content: Text(
                                            "Do you want to cancel your booking? \nTime: ${_repos.getTime(i)} \nDate: ${_repos.getDate(i)}",
                                            style: GoogleFonts.lato(
                                              fontSize:
                                                  customSize(context).height *
                                                      0.018,
                                            ),
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                _repos
                                                    .deleteBooking(i)
                                                    .then((value) {
                                                  Navigator.of(ctx).pop(true);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Successfully canceled the slots");
                                                }).then((value) {
                                                  _repos.getBookedList[i] =
                                                      Booked(
                                                          id: _repos
                                                              .getBookedList[i]
                                                              .id,
                                                          startTime: _repos
                                                              .getBookedList[i]
                                                              .startTime,
                                                          endTime: _repos
                                                              .getBookedList[i]
                                                              .endTime,
                                                          userId: null);
                                                });
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            CupertinoDialogAction(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        ),
                                      )
                                    : showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                              "Are you sure?",
                                              style: GoogleFonts.lato(
                                                color: Colors.red,
                                              ),
                                            ),
                                            content: Text(
                                              "Do you want to cancel your booking? \nTime: ${_repos.getTime(i)} \nDate: ${_repos.getDate(i)}",
                                              style: GoogleFonts.lato(),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text("Yes"),
                                                onPressed: () {
                                                  _repos
                                                      .deleteBooking(i)
                                                      .then((value) {
                                                    Navigator.of(ctx).pop(true);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Successfully canceled the slots");
                                                  }).then((value) {
                                                    _repos
                                                            .getBookedList[i] =
                                                        Booked(
                                                            id: _repos
                                                                .getBookedList[
                                                                    i]
                                                                .id,
                                                            startTime: _repos
                                                                .getBookedList[
                                                                    i]
                                                                .startTime,
                                                            endTime: _repos
                                                                .getBookedList[
                                                                    i]
                                                                .endTime,
                                                            userId: null);
                                                  });
                                                },
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                child: const Text("No"),
                                              ),
                                            ],
                                          );
                                        });
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            onTap: () {
                              customNavigator(
                                context,
                                RoomDetailUI(
                                  room: _room,
                                  user: widget.user,
                                  selectedDate: _selectedDate,
                                ),
                              );
                            },
                            title: Text(
                              Intl().date("h:mm a").format(_bookingList[i]
                                      .booked!
                                      .startTime
                                      .toDate()) +
                                  " - " +
                                  Intl().date("h:mm a").format(
                                      _bookingList[i].booked!.endTime.toDate()),
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(_room.room),
                          );
                        },
                      ),
                    );
                  }, childCount: _bookingList.length),
                );
              }),
        ],
      ),
    );
  }
}
