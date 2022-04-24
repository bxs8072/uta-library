import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/uis/items_ui/components/item_detail_card.dart';
import 'package:uta_library/uis/items_ui/components/items_ui_app_bar.dart';

class ItemsUI extends StatelessWidget {
  final User user;
  const ItemsUI({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ItemsUIAppBar(),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Items").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return GestureDetector(
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                        snapshot.data!.docs[i]["photo"]),
                                  ),
                                  Text(snapshot.data!.docs[i]["title"]),
                                  Text(snapshot.data!.docs[i]["quantity"]
                                      .toString()),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailCard(
                                      quantity: (snapshot.data!.docs[i]
                                              ["quantity"])
                                          .toString(),
                                      timeLimit: (snapshot.data!.docs[i]
                                                  ["timeLimit"] /
                                              60.toInt())
                                          .toString(),
                                      title: (snapshot.data!.docs[i]["title"])
                                          .toString(),
                                      description: (snapshot.data!.docs[i]
                                              ["description"])
                                          .toString(),
                                      photo: (snapshot.data!.docs[i]["photo"])
                                          .toString())));
                            });
                      },
                      childCount: snapshot.data!.docs.length,
                    ));
              }),
        ],
      ),
    );
  }
}
