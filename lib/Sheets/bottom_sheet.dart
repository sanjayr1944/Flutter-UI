import 'package:flutter/material.dart';


class BottomSheetScreen extends StatelessWidget {
  const BottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: ()
        {
          // showModalBottomSheet(
          //   context: context,
          //   builder: (context){
          //     return SizedBox(height: 200,
          //     child: Column(
          //       children: [
          //         ListTile(
          //           leading: Icon(Icons.home),
          //           title: Text("Home"),
          //         ),
          //         ListTile(
          //           leading: Icon(Icons.settings),
          //           title: Text("Settings"),
          //         ),
          //
          //       ],
          //     ),);
          //   }
          // );


          showDialog(context: context,
              builder: (dialogContext)
              {
                return AlertDialog(
                  title: Text("Hi, User"),
                  content: Text("Welcome to Flutter Session"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(dialogContext);
                    }, child: Text("Close")),
                  ],
                );
              });
        }, child: Text("Open Bottom Sheet")),
      ),
    );
  }
}
