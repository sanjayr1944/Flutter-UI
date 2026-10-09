import 'package:flutter/material.dart';


class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The Widgets Which Gives Children Properties in Flutter?
      //Difference Between Child and Children, Text and RichText?
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start, //Default is start
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hello World"),
            Text("Hello World"),
            Text("Hello World"),
          ],

        ),
      )
    );
  }
}
