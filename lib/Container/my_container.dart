import 'package:flutter/material.dart';


class MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body:
        Center(
          child: Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              //shape: BoxShape.
                color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 4,
                color: Colors.greenAccent,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(Icons.person)
          ),
        ),
    );
  }
}
