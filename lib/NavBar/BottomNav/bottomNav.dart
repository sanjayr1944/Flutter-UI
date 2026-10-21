import 'package:flutter/material.dart';

import '../../Routes/Screens/home_screen.dart';
import '../../Routes/Screens/profile_screen.dart';
import '../../Routes/Screens/settings_screen.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int currentIndex = 0;


  final List<Widget> screens = [
    HomeScreen(), //0
    ProfileScreen(),
    SettingsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bottom Nav"),),
      body:
      screens[currentIndex],
      bottomNavigationBar : NavigationBar
        (
        selectedIndex: currentIndex,
          onDestinationSelected: (index)
          {
            setState(() {
              currentIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,

          destinations:
          [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
          ] )
    );
  }
}
