import 'package:flutter/material.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("M O B I L E",
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 350,
              //width: 400,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(),
              ),
              child: Center(child: IconButton(onPressed: (){},
                  icon: Icon(Icons.play_arrow),
                color: Colors.red,
              ),
              ),
            ),
          ),

          Expanded(child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Container(
                height: 250,
                //width: 100,
                color: Colors.red,
              ),
              SizedBox(height: 10,),
              Container(
                height: 250,
                //width: 100,
                color: Colors.red,
              ),
              SizedBox(height: 10,),
              Container(
                height: 250,
                //width: 100,
                color: Colors.red,
              ),
              SizedBox(height: 10,),
              Container(
                height: 250,
                //width: 100,
                color: Colors.red,
              ),
              SizedBox(height: 10,),

            ],
          ))
        ],
      ),
    );
  }
}
