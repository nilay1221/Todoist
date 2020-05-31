
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/app/admin/admin_home_page.dart';
import 'package:todoist/app/landing_page.dart';
import 'package:todoist/pages/admin_dashboard.dart';
import 'package:todoist/pages/home.dart';
import 'package:todoist/utils/theme.dart';

import 'models/Models.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
  //   SharedPreferences.getInstance().then((prefs) {
  //     var isLight = prefs.getBool('isLight') ?? false;
  //     runApp(
  //       ChangeNotifierProvider<AppTheme>(
  //         create: (_) => AppTheme(isLight),
  //         child: MyApp(),
  //       ),
  //     );
  //   });
  // });

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (context) => User(),),
        ChangeNotifierProvider<AppTheme>(create: (context) => AppTheme(),),
         ChangeNotifierProvider<TaskStats>(create: (context) => TaskStats(),)
      ],
      child: MaterialApp(
        title: "Todoist App",
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => HomeLoading(),
        '/home' : (context) => HomeDisplay()
      },
)
      
      );
  }
}
