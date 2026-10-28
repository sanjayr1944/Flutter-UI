import 'package:demo_test/Provider/second_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_model.dart';



class MyCounterHome extends StatefulWidget {
  const MyCounterHome({super.key});
  @override
  State<MyCounterHome> createState() => _MyCounterHomeState();
}

class _MyCounterHomeState extends State<MyCounterHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder:((context, homeValue, child) => Scaffold(
        appBar: AppBar(
          title: Text(homeValue.countValue.last.toString(),
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
        ),


        body: SizedBox(
          child: Column(
            children: [

              //------------------------ Total Value ---------------------------
              Expanded(
                child: ListView.builder(
                  itemCount: homeValue.countValue.length,
                    itemBuilder:(context,index)
                    {
                      return Text(homeValue.countValue[index].toString());
                    } ),
              ),
              ElevatedButton(onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    MySecondHome()));
              }, child: Text("GO TO SCREEN 2"))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          homeValue.add();
        },
        child: Icon(Icons.add),
        ),
      )),
    );
  }
}
