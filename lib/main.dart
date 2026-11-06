import 'package:demo_test/Provider/home.dart';
import 'package:demo_test/Provider/list_model.dart';
import 'package:demo_test/Provider/theme_model.dart';
// import 'package:demo_test/ResposiveDesign/Design/MyLayoutScreen.dart';
// import 'package:demo_test/ResposiveDesign/Design/mobileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'ResposiveDesign/Design/desktopScreen.dart';
import 'constants/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: MyLayoutScreen(
    //       mobileScreen: MobileScreen(),
    //       desktopScreen: DesktopScreen()),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeModel.themeMode,
            home: const MyCounterHome(),
          );
        },
      ),
    );
  }
}
