import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';
import 'package:uta_library/uis/rooms_ui/components/room_detail_card.dart';
import 'package:uta_library/uis/rooms_ui/components/rooms_ui_app_bar.dart';

class RoomsUI extends StatelessWidget {
  final User user;
  const RoomsUI({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const RoomsUIAppBar(),

          //Render the list of all the rooms with their details
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Rooms").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  List<Room> _list = snapshot.data!.docs
                      .map((e) => Room.fromDocumentSnapshot(e))
                      .toList();

                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return RoomDetailCard(
                        onTap: () {
                          //Navigate to room detail page when user tap on the room
                          customNavigator(
                              context,
                              RoomDetailUI(
                                room: _list[i],
                                user: user,
                                selectedDate: DateTime.now(),
                              ));
                        },
                        room: _list[i].room,
                        location: _list[i].location,
                        features: _list[i].features,
                        capacity: _list[i].capacity.toString(),
                      );
                    },
                    childCount: _list.length,
                  ));
                }
              }),
        ],
      ),
    );
  }
}
