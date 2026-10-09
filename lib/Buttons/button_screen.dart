import 'package:flutter/material.dart';

class ButtonScreen extends StatelessWidget {
  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Elevated Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, //1st
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(),//2nd
                ),
              ),
              onPressed:
                  () //
                  {
                    print("Elevated Button Triggered");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Elevated Button Triggered"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
              //Foreground Color.
              child: Text("Elevated Button"), //Signup,Signin,Submit,etc
            ),
          ),
          SizedBox(height: 10),
          //Outlined Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 2),
              shape: RoundedRectangleBorder(),
            ),
            onPressed: () {},
            child: Text("Outlined Button"),
          ),

          //Text Button

          //Icon Button
          //FloatingActionButton
        ],
      ),
    );
  }
}
