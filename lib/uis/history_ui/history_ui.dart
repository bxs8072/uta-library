import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/models/booking.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';

class HistoryUI extends StatefulWidget {
  final User user;
  const HistoryUI({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryUI> createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "History",
              style: GoogleFonts.lato(
                color: ThemeTools.secondaryColor,
                fontSize: ThemeTools.appBarTitleSize(context),
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: ThemeTools.appBarForeGroundColor(context),
          ),
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.only(
                top: customSize(context).width * 0.05,
                bottom: customSize(context).width * 0.03,
                left: customSize(context).width * 0.15,
                right: customSize(context).width * 0.15,
              ),
              child: DateTimeFormField(
                initialDate: DateTime.now(),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.event_note),
                  labelText: 'Date',
                  labelStyle: GoogleFonts.lato(
                    fontSize: customSize(context).height * 0.022,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                dateTextStyle: GoogleFonts.lato(
                  fontSize: customSize(context).height * 0.02,
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                initialValue: DateTime.now(),
                onDateSelected: (DateTime value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("RoomBookings")
                  .where('booked.userId', isEqualTo: widget.user.uid)
                  .where("date",
                      isEqualTo:
                          Timestamp.fromDate(DateUtils.dateOnly(_selectedDate)))
                  .orderBy("booked.startTime")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: customSize(context).height * 0.2),
                      child: Text(
                        "No History Found!!!",
                        style: GoogleFonts.lato(
                          fontSize: customSize(context).height * 0.022,
                        ),
                      ),
                    ),
                  );
                }
                List<Booking> _bookings = snapshot.data!.docs
                    .map((e) => Booking.fromDocumentSnapshot(e))
                    .toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () async {
                            customNavigator(
                              context,
                              RoomDetailUI(
                                  selectedDate: _selectedDate,
                                  room: Room.fromDocumentSnapshot(
                                      await FirebaseFirestore.instance
                                          .collection("Rooms")
                                          .doc(_bookings[i].roomId.toString())
                                          .get()),
                                  user: widget.user),
                            );
                          },
                          title: Text(Intl()
                              .date("MM/dd/yyyy hh:mm a")
                              .format(_bookings[i].booked!.startTime.toDate())),
                          subtitle: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Rooms")
                                .doc(_bookings[i].roomId.toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text("....");
                              }
                              Room room =
                                  Room.fromDocumentSnapshot(snapshot.data!);
                              return Text(
                                room.location,
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                ),
                              );
                            },
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                    );
                  }, childCount: _bookings.length),
                );
              }),
        ],
      ),
    );
  }
}
