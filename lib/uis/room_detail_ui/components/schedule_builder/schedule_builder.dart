import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/booking.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_error_dialog.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/room_detail_ui/components/schedule_builder/room_booking_repository.dart';
import 'package:uta_library/uis/room_detail_ui/components/schedule_builder/scheduled_room_components.dart';

class ScheduleBuilder extends StatelessWidget {
  final User user;
  final Room room;

  final DateTime selectedDate;
  const ScheduleBuilder({
    Key? key,
    required this.user,
    required this.room,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomBookingRepository _repos = RoomBookingRepository(
        room: room, selectedDate: selectedDate, user: user);
    _repos.setBookedList();
    // Render the list of all booked slot for selected date and room
    return StreamBuilder<QuerySnapshot>(
        stream: _repos.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SliverToBoxAdapter(
              child: Text("Loading....."),
            );
          }

          List<Booking> _bookings = snapshot.data!.docs
              .map((e) => Booking.fromDocumentSnapshot(e))
              .toList();

          _repos.updateBookedList(_bookings);

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                return Card(
                  child: ListTile(
                      leading: ScheduledRoomComponents.isAvailableCircle(
                        _repos.availableColor(i),
                      ),
                      title:
                          ScheduledRoomComponents.timeText(_repos.getTime(i)),
                      trailing: _repos.getBookedList[i].userId == user.uid
                          ? IconButton(
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
                            )
                          : _repos.isRoomAvailable(i)
                              ? IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    if (await _repos.isDailyLimitReached(i)) {
                                      CustomErrorDialog.dailyLimit(context, i);
                                    } else if (await _repos.isTimeConflict(
                                        _repos.getBookedList[i].startTime)) {
                                      CustomErrorDialog.timeConflict(context);
                                    } else {
                                      Platform.isIOS
                                          ? showCupertinoDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (ctx) =>
                                                  CupertinoAlertDialog(
                                                title: Text(
                                                  "Are you sure?",
                                                  style: GoogleFonts.lato(
                                                      letterSpacing: 1.5,
                                                      color: ThemeTools
                                                          .secondaryColor,
                                                      fontSize:
                                                          customSize(context)
                                                                  .height *
                                                              0.022),
                                                ),
                                                content: Text(
                                                  "Do you want to book the room? \nTime: ${_repos.getTime(i)} \nDate: ${_repos.getDate(i)}",
                                                  style: GoogleFonts.lato(
                                                      fontSize:
                                                          customSize(context)
                                                                  .height *
                                                              0.018),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    onPressed: () {
                                                      _repos
                                                          .addBooking(i)
                                                          .then((value) {
                                                        Navigator.of(ctx)
                                                            .pop(true);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Successfully booked the slots");
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
                                                          BorderRadius.circular(
                                                              20)),
                                                  title: Text(
                                                    "Are you sure?",
                                                    style: GoogleFonts.lato(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Do you want to book the room? \nTime: ${_repos.getTime(i)} \nDate: ${_repos.getDate(i)}",
                                                    style: GoogleFonts.lato(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text("Yes"),
                                                      onPressed: () {
                                                        _repos
                                                            .addBooking(i)
                                                            .then((value) {
                                                          Navigator.of(ctx)
                                                              .pop(true);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Successfully booked the slots");
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
                                    }
                                  },
                                )
                              : const SizedBox()),
                );
              },
              childCount: _repos.getBookedList.length,
            ),
          );
        });
  }
}
