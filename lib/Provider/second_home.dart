import 'package:demo_test/Provider/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_model.dart';

class MySecondHome extends StatefulWidget {
  const MySecondHome({super.key});

  @override
  State<MySecondHome> createState() => _MySecondHomeState();
}

class _MySecondHomeState extends State<MySecondHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: ((context, secondValue, child) => Scaffold(
            appBar: AppBar(
              title: Text('Screen 2 - ${secondValue.countValue.isNotEmpty ? secondValue.countValue.last : 0}'),
              actions: [
                Consumer<ThemeModel>(
                  builder: (context, themeModel, child) {
                    return IconButton(
                      icon: Icon(
                        themeModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                      tooltip: 'Toggle Theme',
                      onPressed: () {
                        themeModel.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  //------------------------ Total Value ---------------------------
                  SizedBox(
                    height: 120,
                    width: double.maxFinite,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: secondValue.countValue.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: Text(
                              secondValue.countValue[index].toString(),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                secondValue.add();
              },
              child: const Icon(Icons.add),
            ),
          )),
    );
  }
}
