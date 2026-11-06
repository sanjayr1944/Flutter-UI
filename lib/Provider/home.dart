import 'package:demo_test/Provider/second_home.dart';
import 'package:demo_test/Provider/theme_model.dart';
import 'package:demo_test/Provider/theme_screen.dart';
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
      builder: ((context, homeValue, child) => Scaffold(
            appBar: AppBar(
              title: Text('Counter: ${homeValue.countValue.isNotEmpty ? homeValue.countValue.last : 0}'),
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
                IconButton(
                  icon: const Icon(Icons.color_lens_outlined),
                  tooltip: 'Theme Screen',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ThemeScreen(),
                      ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: homeValue.countValue.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Item ${homeValue.countValue[index]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MySecondHome(),
                              ),
                            );
                          },
                          child: const Text("GO TO SCREEN 2"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ThemeScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.palette),
                          label: const Text("THEME SCREEN"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                homeValue.add();
              },
              child: const Icon(Icons.add),
            ),
          )),
    );
  }
}
