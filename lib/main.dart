import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pdf_creator/Screens/homescreen/dashboard.dart';
import 'package:pdf_creator/provider/documentprovider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DocumentProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}
