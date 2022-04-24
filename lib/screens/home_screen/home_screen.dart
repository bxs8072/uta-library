import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/pages/dashboard/dashboard.dart';
import 'package:uta_library/pages/profile_page/profile_page.dart';
import 'package:uta_library/pages/room_booked_page/room_booked_page.dart';
import 'package:uta_library/screens/home_screen/home_screen_bloc.dart';
import 'package:uta_library/tools/app_drawer/app_drawer.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/notification_service.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/room_detail_ui/room_detail_ui.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotificationService.instance.fetchData(user: widget.user);
    NotificationService.instance.notificationPlugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings(
            '@mipmap/ic_launcher',
          ),
          iOS: IOSInitializationSettings()),
      onSelectNotification: (payload) {
        Map<String, dynamic> data = json.decode(payload!);

        customNavigator(
          context,
          RoomDetailUI(
            selectedDate: DateTime.parse(data["selectedDate"].toString()),
            room: Room.fromJson(data["room"]),
            user: User.fromJson(
              data["user"],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenBloc _bloc = HomeScreenBloc();
    return StreamBuilder<int>(
      stream: _bloc.stream,
      initialData: 0,
      builder: (context, snapshot) {
        return Scaffold(
            drawer: AppDrawer(user: widget.user),
            body: [
              Dashboard(user: widget.user),
              RoomBookedPage(
                user: widget.user,
                canPop: false,
              ),
              ProfilePage(user: widget.user),
            ][snapshot.data!],
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: snapshot.data!,
              onItemSelected: (index) {
                _bloc.update(index);
              },
              items: [
                BottomNavyBarItem(
                  icon: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  activeColor:
                      ThemeTools.bottomNavigationBarForegroundColor(context),
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.calendar_today),
                  title: const Text('Booked'),
                  activeColor:
                      ThemeTools.bottomNavigationBarForegroundColor(context),
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                  activeColor:
                      ThemeTools.bottomNavigationBarForegroundColor(context),
                ),
              ],
            ));
      },
    );
  }
}
