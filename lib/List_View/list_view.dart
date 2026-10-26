import 'package:demo_test/List_View/post.dart';
import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  ListViewScreen({super.key});

  final List<String> posts = ["POST 1", "POST 2", "POST 3", "POST 4"];
  final List<String> story = ["STORY 1", "STORY 2", "STORY 4", "STORY 5"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
                itemBuilder: (context, index)
                {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle
                    ),
                    child: Text(posts[index]),
                  );
                }),
          ),


          //Post - Insta
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostScreen(child: posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
