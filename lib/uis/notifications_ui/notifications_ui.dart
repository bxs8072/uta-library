import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/uis/notifications_ui/components/notifications_ui_app_bar.dart';
import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';

class NotificationsUI extends StatelessWidget {
  final User user;
  const NotificationsUI({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          NotificationsUIAppBar(key: key),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Card(
                color: Colors.red,
                shape: CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.clear_all,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                "Clear Notifications",
                style: GoogleFonts.lato(),
              ),
              subtitle: Text(
                "Clear all the notifications",
                style: GoogleFonts.lato(),
              ),
              trailing: IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Notifications")
                      .doc(user.uid)
                      .collection("Notifications")
                      .get()
                      .then((value) {
                    // ignore: avoid_function_literals_in_foreach_calls
                    value.docs.forEach((element) {
                      element.reference.delete();
                    });
                  });
                },
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Notifications")
                  .doc(user.uid)
                  .collection("Notifications")
                  .snapshots(),
              builder: (context, snaphsot) {
                if (!snaphsot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            customNavigator(
                              context,
                              RoomDetailUI(
                                  selectedDate: snaphsot.data!
                                      .docs[i]["body"]["roomBooked"]["date"]
                                      .toDate(),
                                  room: Room.fromJson(
                                      snaphsot.data!.docs[i]["body"]["room"]),
                                  user: User.fromJson(
                                      snaphsot.data!.docs[i]["body"]["user"])),
                            );
                          },
                          contentPadding: const EdgeInsets.all(12.0),
                          title: Text(
                            snaphsot.data!.docs[i]["title"],
                            style: GoogleFonts.lato(),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snaphsot.data!.docs[i]["body"]["room"]["room"],
                                style: GoogleFonts.lato(),
                              ),
                              Text(
                                "Date: " +
                                    Intl().date("MM/d/y").format(snaphsot
                                        .data!
                                        .docs[i]["body"]["roomBooked"]["booked"]
                                            ["startTime"]
                                        .toDate()) +
                                    "\nStarted Time: " +
                                    Intl().date("HH:mm a").format(
                                          snaphsot
                                              .data!
                                              .docs[i]["body"]["roomBooked"]
                                                  ["booked"]["startTime"]
                                              .toDate(),
                                        ),
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("Notifications")
                                  .doc(user.uid)
                                  .collection("Notifications")
                                  .doc(snaphsot.data!.docs[i].id)
                                  .delete();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snaphsot.data!.docs.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
