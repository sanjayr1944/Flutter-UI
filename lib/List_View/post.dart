import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
   PostScreen({super.key, required this.child});

  final String child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
    child: Container(
      height: 400,
      color: Colors.amber,
      child: Text(child),
    ),);
  }
}
