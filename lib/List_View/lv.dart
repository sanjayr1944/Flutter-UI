import 'package:demo_test/List_View/post.dart';
import 'package:flutter/material.dart';


class LvScreen extends StatelessWidget {
   LvScreen({super.key});


  List<String> posts = ["Post 1", "Post 2", "Post 3", "Post 4", "Post 5", "Post 6"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 900,
            child: ListView.builder
                (
              scrollDirection: Axis.vertical,//Horizontel shape -Circular, Post picture
                itemCount: posts.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index)
                  {
                    return
                      Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return PostScreen(child: posts[index]);
                          },
                        ),
                      );
                  } ),
          ),
        ],
      ),
      );
  }
}


//List View

// ListView(
// padding: EdgeInsets.all(10),
// children: [
// Container(
// height: 200,
// color: Colors.amber,
// ),
//
// SizedBox(
// height: 10,
// ),
//
// Container(
// height: 200,
// color: Colors.blue,
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// height: 200,
// color: Colors.amber,
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// height: 200,
// color: Colors.blue,
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// height: 200,
// color: Colors.amber,
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// height: 200,
// color: Colors.blue,
// ),
// SizedBox(
// height: 10,
// ),
// ],
// )
