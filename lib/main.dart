
// import 'package:demo_test/OverFlow/overflow.dart';
import 'package:demo_test/Routes/Screens/home_screen.dart';
import 'package:demo_test/Routes/Screens/settings_screen.dart';
// import 'package:demo_test/Sheets/bottom_sheet.dart';
import 'package:flutter/material.dart';
// import 'Gestures/gestures.dart';
import 'Routes/Screens/profile_screen.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: BottomSheetScreen(),
      initialRoute: "/",
      routes:
      {
        "/":(context) =>  HomeScreen(),// initial
        "/profile":(context) => ProfileScreen(),
        "/settings":(context) => SettingsScreen(),

      },
    );
  }
}
