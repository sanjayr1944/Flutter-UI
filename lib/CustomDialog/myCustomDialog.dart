import 'package:flutter/material.dart';


class MyCustomDialog extends StatelessWidget {
  const MyCustomDialog({super.key});

  void showCustomDialog(BuildContext context)
  {
    showDialog(context: context, builder: (BuildContext context)
    {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 35,
              foregroundColor: Colors.white,
              child: Icon(Icons.check,
              size: 45,),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Success",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(
              height: 10,
            ),
            Text("Your Operation Completed Successfully",
            textAlign: .center,
            style: TextStyle(
              fontSize: 16,
            ),
            ),


            SizedBox(
              height: 24,
            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              onPressed: (){
              Navigator.pop(context);
            }, child: Text("Success"),
            ),

          ],
        ),
      );

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        ElevatedButton(onPressed: ()
        {
          showCustomDialog(context);
        },
            child: Text("Open Dialog")),
      )
    );
  }
}
