import 'package:flutter/material.dart';


class GridScreen extends StatelessWidget {
   GridScreen({super.key});

  List <Widget> gallerys = [
    Center(child: Image.network(""),),
   Center(child: Image.network("")
    ) //-- First Index
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid View"),
      ),
      body: GridView.builder(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,),
          itemCount: gallerys.length,
          itemBuilder: (context, index)
          {
            return Container(
              height: 100,
              width: 100,
              color: Colors.blue,
            );
          })
      // body: GridView.count(
      //   //physics: NeverScrollableScrollPhysics(),
      //     crossAxisCount: 4, //3x3 = 9 4x12
      // crossAxisSpacing: 10,
      // mainAxisSpacing: 10,
      // padding: EdgeInsets.all(10),
      // children:
      // [
      //   Container(color: Colors.amber,),
      //   Container(color: Colors.green,),
      //   Container(color: Colors.black,),
      //   Container(color: Colors.blue,),
      //   Container(color: Colors.pink,),
      //   Container(color: Colors.red,),
      //   Container(color: Colors.amber,),
      //   Container(color: Colors.green,),
      //   Container(color: Colors.black,),
      //   Container(color: Colors.blue,),
      //   Container(color: Colors.pink,),
      //   Container(color: Colors.red,),
      // ]),

    );
  }
}



