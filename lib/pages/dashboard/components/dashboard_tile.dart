import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class DashboardTile extends StatelessWidget {
  final String title, subtitle;
  final IconData leadingIcon;
  final void Function()? onTap;
  const DashboardTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: customSize(context).width * 0.02,
          vertical: customSize(context).width * 0.01),
      sliver: SliverToBoxAdapter(
        child: Card(
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
            subtitle: Text(subtitle),
            leading: Card(
              color: ThemeTools.secondaryColor,
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  leadingIcon,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
