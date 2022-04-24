import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final void Function()? onTap;
  const DashboardTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(customSize(context).width * 0.02),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          contentPadding: const EdgeInsets.all(15.0),
          title: Text(
            title,
            style: GoogleFonts.lato(
              fontSize: customSize(context).height * 0.03,
              fontWeight: FontWeight.bold,
              // color: Colors.white,
            ),
          ),
          leading: Icon(
            leadingIcon,
            size: customSize(context).height * 0.035,
            color: ThemeTools.secondaryColor,
          ),
          trailing: Icon(
            Icons.forward,
            color: ThemeTools.secondaryColor,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
