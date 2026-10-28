
// import 'package:demo_test/OverFlow/overflow.dart';
import 'package:demo_test/Grid_view/grid_view.dart';
import 'package:demo_test/List_View/list_view.dart';
import 'package:demo_test/List_View/lv.dart';
import 'package:demo_test/NavBar/BottomNav/bottomNav.dart';
import 'package:demo_test/Provider/home.dart';
import 'package:demo_test/Provider/list_model.dart';
import 'package:demo_test/Reordering/reordering.dart';
import 'package:demo_test/ResposiveDesign/Design/MyLayoutScreen.dart';
import 'package:demo_test/ResposiveDesign/Design/mobileScreen.dart';
import 'package:demo_test/ResposiveDesign/MyMediaQuery.dart';
import 'package:demo_test/Routes/Screens/home_screen.dart';
import 'package:demo_test/Routes/Screens/settings_screen.dart';
import 'package:demo_test/Swipe/dismissable.dart';
import 'package:demo_test/constants/theme/themeProvider/theme_provider.dart';
// import 'package:demo_test/Sheets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'Gestures/gestures.dart';
import 'CustomDialog/myCustomDialog.dart';
import 'ResposiveDesign/Design/desktopScreen.dart';
import 'Routes/Screens/profile_screen.dart';
import 'constants/theme/app_theme.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> CounterModel()),
        ChangeNotifierProvider(create: (context)=>ThemeProvider())
      ],
      child: MaterialApp
        (
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: AppTheme.primaryColor,
          secondaryHeaderColor: AppTheme.lightPrimaryColor,
          scaffoldBackgroundColor: AppTheme.lightPrimaryColor,
        ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: AppTheme.primaryColor,
            secondaryHeaderColor: AppTheme.lightPrimaryColor,
            scaffoldBackgroundColor: AppTheme.darkPrimaryColor,
          ),
        themeMode: proiver.Theme,
        home: MyCounterHome()
      ),
    );
  }
}
