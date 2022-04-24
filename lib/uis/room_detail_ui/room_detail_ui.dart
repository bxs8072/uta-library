import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/app_drawer/app_drawer.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/room_detail_ui/components/features_card.dart';
import 'package:uta_library/uis/room_detail_ui/components/schedule_builder/schedule_builder.dart';

class RoomDetailUI extends StatefulWidget {
  final Room room;
  final User user;
  final DateTime selectedDate;
  const RoomDetailUI({
    Key? key,
    required this.selectedDate,
    required this.room,
    required this.user,
  }) : super(key: key);

  @override
  State<RoomDetailUI> createState() => _RoomDetailUIState();
}

class _RoomDetailUIState extends State<RoomDetailUI> {
  DateTime? _selectedDate;

  bool _showDetail = false;

  _toggleShowDetail() {
    setState(() {
      _showDetail = !_showDetail;
    });
  }

  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = DateUtils.dateOnly(widget.selectedDate);
      _dateTimeController.text =
          Intl().date("EEEE, d MMM, yyyy").format(_selectedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(user: widget.user),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const BackButton(),
            pinned: true,
            title: Text(
              widget.room.room,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: ThemeTools.appBarForeGroundColor(context),
          ),

          //detail card
          SliverToBoxAdapter(
            child:
                //Show and hide library room detail according to the conditions
                _showDetail
                    ? FeaturesCard(
                        room: widget.room,
                        onTap: _toggleShowDetail,
                        key: widget.key,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(
                              "Show Detail",
                              style: GoogleFonts.lato(
                                fontSize: customSize(context).height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: ThemeTools.primaryColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.expand_more,
                              color: ThemeTools.appBarForeGroundColor(context),
                            ),
                            onTap: _toggleShowDetail,
                          ),
                        ),
                      ),
          ),

          //Popup DatePicker to choose the date for booking the room
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: customSize(context).width * 0.22, vertical: 10),
              child: TextField(
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                ),
                controller: _dateTimeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeTools.appBarForeGroundColor(context),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeTools.appBarForeGroundColor(context),
                    ),
                  ),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDatePickerMode: DatePickerMode.day,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year, 12, 31),
                    currentDate: _selectedDate,
                  ).then((value) {
                    setState(() {
                      _selectedDate = DateUtils.dateOnly(value!);
                      _dateTimeController.text = Intl()
                          .date("EEEE, d MMM, yyyy")
                          .format(_selectedDate!);
                    });
                  });
                },
                readOnly: true,
                keyboardType: TextInputType.datetime,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Row(
              children: [
                const Card(
                  color: Colors.green,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                  ),
                ),
                Text(
                  "Available",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                const Card(
                  color: Colors.red,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                  ),
                ),
                Text(
                  "Booked",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverToBoxAdapter(
              child: Text(
            "Schedules",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: customSize(context).height * 0.025),
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          //Render all the available time slots for the selected date by the user
          ScheduleBuilder(
            selectedDate: _selectedDate!,
            key: widget.key,
            user: widget.user,
            room: widget.room,
          )
        ],
      ),
    );
  }
}
