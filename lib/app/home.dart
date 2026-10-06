import 'package:flutter/material.dart';
import 'package:mr_market/app/theme/app_theme.dart';
import 'package:mr_market/features/splash_screen/splash_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   fontFamily: "Vazirmatn",
      //   scaffoldBackgroundColor: Color.fromARGB(255, 242, 242, 247),
      //   textTheme: TextTheme(
      //     bodyLarge: TextStyle(
      //       fontSize: 40,
      //       fontFamily: "Vazirmatn",
      //     ),
      //     bodyMedium: TextStyle(
      //       fontSize: 20,
      //       fontFamily: "Vazirmatn",
      //     )
      //   )
      // ),
      // darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
