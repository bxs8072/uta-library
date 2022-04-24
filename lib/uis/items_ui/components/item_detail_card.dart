import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class ItemDetailCard extends StatelessWidget {
  final String quantity, timeLimit, title, description, photo;

  const ItemDetailCard(
      {Key? key,
      required this.quantity,
      required this.timeLimit,
      required this.title,
      required this.description,
      required this.photo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RichText _richText(String key, String value) => RichText(
          text: TextSpan(
            style: GoogleFonts.lato(
              fontSize: customSize(context).height * 0.023,
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: ThemeTools.appBarForeGroundColor(context),
            backgroundColor: Colors.transparent,
            pinned: true,
            title: Text(
              title,
              style: GoogleFonts.lato(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 12.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          fontSize: customSize(context).height * 0.030,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.network(
                        photo,
                        height: customSize(context).height * 0.35,
                      ),
                      const SizedBox(height: 10),
                      _richText("Quantity: ", quantity),
                      const SizedBox(height: 10),
                      _richText("Time Limit: ", timeLimit + " Minutes"),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _richText("Description: \n", description),
                      ),
                      //SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
