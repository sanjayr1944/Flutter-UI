
import 'package:flutter/material.dart';


class ReorderingScreen extends StatefulWidget {
  const ReorderingScreen({super.key});

  @override
  State<ReorderingScreen> createState() => _ReorderingScreenState();
}

class _ReorderingScreenState extends State<ReorderingScreen> {


  final List products =
  [
    "Mobile", //0
    "Laptop", //0
    "GPU",
    "Desktop"
  ];


  void updateProducts(int oldIndex, int newIndex)
  {
    setState(() {
      //Changing the index
      if(oldIndex < newIndex)
      {
        newIndex -=1;
      }

      //Where we are Moving
      final product = products.removeAt(oldIndex);
      //Where it is currently At
      products.insert(newIndex, product);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
          children:
          [
            for(var product in products) //Iteration List =[123577]
              ListTile(
                key: ValueKey(product),
                title: Text(product),
              )
          ],
        onReorder: (int oldIndex, int newIndex)
        {
          updateProducts(oldIndex, newIndex);
        }
      ),
    );
  }
}
