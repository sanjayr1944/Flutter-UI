import 'package:flutter/material.dart';


class OverFlowScreen extends StatelessWidget {
  const OverFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              flex: 2,
              child: Container(
                height: 100,

                color: Colors.yellow,
              ),
            ),
            Flexible(
              child: Container(
                height: 100,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
