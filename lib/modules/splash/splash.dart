import 'dart:io';

import 'package:flutter/material.dart';
import 'package:piot/modules/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';
import '../size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.pushNamed(context, HomePage.routeName);
    } else {
      await prefs.setBool('seen', true);
      print("continue");
    }
  }
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
  @override
  void initState() {
    super.initState();
   // checkFirstSeen();
  }

}