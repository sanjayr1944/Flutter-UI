import 'package:flutter/material.dart';



class MyGestureScreen extends StatefulWidget {
  const MyGestureScreen({super.key});

  @override
  State<MyGestureScreen> createState() => _MyGestureScreenState();
}

class _MyGestureScreenState extends State<MyGestureScreen> {

  String gestureMessage = "Interact";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            setState(()
            {
              gestureMessage = "Tapped!";
            });
            },
          onHorizontalDragUpdate: (details)
          {
            setState(()
            {
              gestureMessage = "Dragged!";
            });
          },
          onDoubleTap: (){
            setState(()
            {
              gestureMessage = "Double Tap!";
            });
          },
          onLongPress: (){
            setState(()
            {
              gestureMessage = "Long Press!";
            });
          },




          child: Container(
            width: 280,
            height: 220,
            alignment: .center,
            color: Colors.amber,
            child: Text(gestureMessage,textAlign: TextAlign.center,),

          )
      ),
      )
    );
  }
}
