import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class RoomDetailCard extends StatelessWidget {
  final String room, location, features, capacity;
  final void Function()? onTap;
  const RoomDetailCard({
    Key? key,
    required this.room,
    required this.location,
    required this.features,
    required this.capacity,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RichText _richText(String key, String value) => RichText(
          text: TextSpan(
            style: GoogleFonts.lato(
              fontSize: customSize(context).height * 0.02,
              fontWeight: FontWeight.bold,
              color:
                  ThemeTools.isDarkMode(context) ? Colors.white : Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: key,
              ),
              TextSpan(
                text: value,
              ),
            ],
          ),
        );

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          elevation: 8.0,

          // color:
          //     ThemeTools.isDarkMode(context) ? Colors.black : Colors.blue[500],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room,
                  style: GoogleFonts.lato(
                    fontSize: customSize(context).height * 0.024,
                    fontWeight: FontWeight.bold,
                    color: ThemeTools.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                _richText("Capacity: ", capacity + " People"),
                const SizedBox(height: 5),
                _richText("Location: ", location),
                const SizedBox(height: 5),
                _richText("Features: ", features),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.wheelchair_pickup,
                      // color: Colors.white,
                      size: customSize(context).height * 0.035,
                    ),
                    Icon(
                      Icons.power,
                      // color: Colors.white,
                      size: customSize(context).height * 0.035,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
