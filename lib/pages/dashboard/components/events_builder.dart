import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/tools/custom_size.dart';

class EventsBuilder extends StatelessWidget {
  const EventsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      elevation: 6.0,
      margin: EdgeInsets.all(customSize(context).width * 0.02),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "News & Events",
              style: GoogleFonts.lato(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Events").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    "No events!",
                    style: GoogleFonts.lato(
                      fontSize: customSize(context).height * 0.025,
                    ),
                  ));
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(
                            snapshot.data!.docs[i]["title"],
                            style: GoogleFonts.lato(
                                color: Colors.red,
                                fontSize: customSize(context).height * 0.025),
                          ),
                          trailing: Text(
                            Intl().date("EEEE, d MMM, yyyy").format(
                                snapshot.data!.docs[i]["date"].toDate()),
                            style: GoogleFonts.lato(color: Colors.red),
                          ),
                          subtitle: Text(
                            snapshot.data!.docs[i]["content"],
                            style: GoogleFonts.lato(
                                fontSize: customSize(context).height * 0.022),
                          ),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
