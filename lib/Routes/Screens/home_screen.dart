import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .end,
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.person,size: 35,),

                    ),
                    Text("Flutter Intern"),
                    Text("intern@irohub.com"),
                  ],
                ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Profile"),
              onTap: ()
              {
                Navigator.pushNamed(context, "/profile");
              }
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: (){
                Navigator.pushNamed(context, "/settings");
              },
            ),
            Spacer(),
            ElevatedButton(onPressed: (){}, child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
