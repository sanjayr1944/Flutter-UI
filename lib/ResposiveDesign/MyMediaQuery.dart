import 'package:flutter/material.dart';

class MyMediaQuery extends StatelessWidget {
  const MyMediaQuery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Width : " + MediaQuery.of(context).size.width.toString()),
            Text("Height : " + MediaQuery.of(context).size.height.toString()),
            Text("Aspect Ratio : " + MediaQuery.of(context).size.aspectRatio.toStringAsFixed(2)),
            Text( MediaQuery.of(context).orientation.toString()),
          ]

        ),
      ),
    );
  }
}
