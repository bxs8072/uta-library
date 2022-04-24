import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/room.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class FeaturesCard extends StatelessWidget {
  final Room room;
  final Function()? onTap;
  const FeaturesCard({Key? key, required this.room, this.onTap})
      : super(key: key);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room.room,
                      style: GoogleFonts.lato(
                        fontSize: customSize(context).height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: ThemeTools.primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.expand_less,
                        color: ThemeTools.appBarForeGroundColor(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _richText("Capacity: ", room.capacity.toString() + " People"),
                const SizedBox(height: 5),
                _richText("Location: ", room.location),
                const SizedBox(height: 5),
                _richText("Features: ", room.features),
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
