import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piot/modules/splash/splash.dart';
import 'size_config.dart';
import 'home_page.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}
class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                SplashScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: Colors.white,
        child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}