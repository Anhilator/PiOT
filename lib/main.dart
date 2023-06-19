import 'package:flutter/material.dart';
import 'modules/home_page.dart';
import 'modules/intro.dart';
import 'theme.dart';
import 'routes.dart';
import 'modules/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiOT',
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
