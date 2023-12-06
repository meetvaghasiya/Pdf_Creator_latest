import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Screens/DashBoard Screen/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        centered: true,
        splash: 'assets/images/pdf_logo.jpeg',
        splashIconSize: 400,
        splashTransition: SplashTransition.scaleTransition,
        curve: Curves.easeInOutCubic,
        duration: 1000,
        screenFunction: () async {
          return DashBoard();
        },
      ),
    );
  }
}
