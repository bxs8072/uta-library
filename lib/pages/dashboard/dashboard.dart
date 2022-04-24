import 'package:flutter/material.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/pages/dashboard/components/dashboard_app_bar.dart';
import 'package:uta_library/pages/dashboard/components/dashboard_tile.dart';
import 'package:uta_library/pages/dashboard/components/events_builder.dart';
import 'package:uta_library/pages/dashboard/components/greeting_card.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/uis/items_ui/items_ui.dart';
import 'package:uta_library/uis/rooms_ui/rooms_ui.dart';

class Dashboard extends StatelessWidget {
  final User user;
  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        DashboardAppBar(key: key, user: user),

        SliverToBoxAdapter(
          child: GreetingCard(
            user: user,
            key: key,
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: customSize(context).height * 0.01,
          ),
        ),

        DashboardTile(
          leadingIcon: Icons.house,
          title: "Book Rooms",
          onTap: () {
            customNavigator(context, RoomsUI(user: user));
          },
        ),
        DashboardTile(
          leadingIcon: Icons.calculate,
          title: "Available Items",
          onTap: () {
            customNavigator(context, ItemsUI(user: user));
          },
        ),

        //Render all the upcoming events and news for the library i.e. library closing due to storm

        SliverToBoxAdapter(
          child: EventsBuilder(
            key: key,
          ),
        ),
      ],
    );
  }
}
