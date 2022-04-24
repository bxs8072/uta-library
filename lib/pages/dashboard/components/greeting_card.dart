import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_size.dart';

class GreetingCard extends StatelessWidget {
  final User user;
  const GreetingCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(customSize(context).width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          user.photo == ""
              ? Container(
                  width: MediaQuery.of(context).size.height * 0.12,
                  height: MediaQuery.of(context).size.height * 0.12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    user.initial,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.1,
                      letterSpacing: 1.5,
                    ),
                  ),
                )
              : ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink.image(
                      image: NetworkImage(user.photo!),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.height * 0.12,
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: const InkWell(),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Hello " + user.firstName,
              overflow: TextOverflow.fade,
              style: GoogleFonts.pacifico(
                fontSize: customSize(context).height * 0.028,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
