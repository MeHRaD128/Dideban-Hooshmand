import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mr_market/features/auth/presentation/sign_in.dart';
import 'package:mr_market/features/shared/base/base.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => SignInPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Center(
        child: Image.asset("assets/icons/Aghaye_Bazar_Logo_8K.png"),
      ),
    );
  }
}
