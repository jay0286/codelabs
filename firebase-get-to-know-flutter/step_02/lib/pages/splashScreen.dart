import 'dart:async';

import '/constant/constant.dart';
//import '/pages/login_signup/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:gtk_flutter/main.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';           // new

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 4),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>     ChangeNotifierProvider(
            create: (context) => ApplicationState(),
            builder: (context, _) => App(),
          ),),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/image/helmet.png',
                 width: 100.0,
                 fit: BoxFit.fitWidth,
              ),
              heightSpace,
              Text(
                '스마트안전모',
                style: listItemTitleStyle,
              ),
              heightSpace,
              heightSpace,
              SpinKitPulse(
                color: Colors.deepPurple,//primaryColor,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
