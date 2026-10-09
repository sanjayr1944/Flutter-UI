import 'package:flutter/material.dart';


class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            //gradient:
          ),

          child: Image.network("https://cdn-icons-png.flaticon.com/128/300/300221.png")

        ),
      )
    );
  }
}
