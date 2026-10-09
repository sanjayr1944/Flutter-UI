import 'package:demo_test/Buttons/button_screen.dart';
import 'package:demo_test/Container/my_container.dart';
import 'package:demo_test/Inputs/textformfield_screen.dart';
import 'package:demo_test/Screens/login_screen.dart';
import 'package:demo_test/Text/text_widgets.dart';
import 'package:flutter/material.dart';

import 'images/img.dart';

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
      home: MyLoginScreen(),
    );
  }
}
