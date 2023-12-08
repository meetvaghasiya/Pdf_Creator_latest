import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf_creator/Screens/onboardingscreen/onboardingscreen.dart';

import 'Screens/DashBoard Screen/dashboard.dart';
import 'Utilities/classes.dart';

Future<void> main() async {
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Read the onboarding status from secure storage
  String? onboardingStatus =
      await _secureStorage.read(key: 'onboarding_status');

  runApp(MyApp(
    showOnboarding: onboardingStatus != 'finished',
  ));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        centered: true,
        splash: 'assets/images/splashlogo.png',
        splashIconSize: 400,
        splashTransition: SplashTransition.scaleTransition,
        curve: Curves.easeInOutCubic,
        duration: 1000,
        screenFunction: () async {
          return showOnboarding ? OnboardingScreen() : const DashBoard();
        },
      ),
    );
  }
}
