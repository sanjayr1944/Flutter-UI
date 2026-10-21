import 'package:flutter/material.dart';

class MyLayoutScreen extends StatefulWidget {
  final Widget mobileScreen;
  final Widget desktopScreen;

  const MyLayoutScreen({super.key,
    required this.mobileScreen,
    required this.desktopScreen});

  @override
  State<MyLayoutScreen> createState() => _MyLayoutScreenState();
}

class _MyLayoutScreenState extends State<MyLayoutScreen> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
      if(constraints.maxWidth > 600)
      {
        return widget.desktopScreen;
      }
      else
      {
        return widget.mobileScreen;
      }
    });
  }
}
