import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uta_library/screens/landing_screen/landing_screen.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

initLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZone));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocalTimeZone();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MavStudy());
}

class MavStudy extends StatelessWidget {
  const MavStudy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: ThemeTools.lightMode,
      themes: [
        AppTheme(
            id: ThemeTools.lightMode,
            data: ThemeData(
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.dark),
            ),
            description:
                ""), // This is standard light theme (id is default_light_theme)
        AppTheme.dark(
            id: ThemeTools
                .darkMode), // This is standard dark theme (id is default_dark_theme)
      ],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            debugShowCheckedModeBanner: false,
            home: const LandingScreen(),
          ),
        ),
      ),
    );
  }
}
