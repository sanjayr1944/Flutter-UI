import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'list_model.dart';

class MySecondHome extends StatefulWidget {
  const MySecondHome({super.key,});



  @override
  State<MySecondHome> createState() => _MySecondHomeState();
}

class _MySecondHomeState extends State<MySecondHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder:((context, secondValue, child) => Scaffold(
        appBar: AppBar(
          title: Text(secondValue.countValue.last.toString(),
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
        ),


        body: SizedBox(
          child: Column(
            children: [

              //------------------------ Total Value ---------------------------
              Container(
                height: 200,
                width: double.maxFinite,
                child: ListView.builder(
                  scrollDirection: .horizontal,
                    itemCount: secondValue.countValue.length,
                    itemBuilder:(context,index)
                    {
                      return  Text(secondValue.countValue[index].toString());
                    } ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          secondValue.add();
        },
          child: Icon(Icons.add),
        ),
      )),
    );;
  }
}
