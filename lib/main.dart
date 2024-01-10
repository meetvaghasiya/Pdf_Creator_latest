import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboard.dart';
import 'package:pdf_creator/Screens/onboardingscreen/onboardingscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';

Future<void> main() async {
  await GetStorage.init();

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? onboardingStatus = await secureStorage.read(key: 'onboarding_status');

  runApp( MyApp(
      showOnboarding: onboardingStatus != 'finished',
    ),);
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
        useMaterial3: true,
      ),

      home: AnimatedSplashScreen.withScreenFunction(
        centered: true,
        splash: 'assets/images/splashlogo.png',
        splashIconSize: 400,
        splashTransition: SplashTransition.scaleTransition,
        curve: Curves.easeInOutCubic,
        pageTransitionType: PageTransitionType.rightToLeft,
        duration: 1000,
        screenFunction: () async {
          return showOnboarding ? OnboardingScreen() : DashBoard();
        },
      ),
    );
  }
}





class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String updateCheckUrl =
      'https://raw.githubusercontent.com/meetvaghasiya/Pdf_Creator_latest/main/README.md';
  final String currentAppVersion = '1.0.0'; // Replace with your app's current version

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    try {
      final response = await http.get(Uri.parse(updateCheckUrl));
      final data = json.decode(response.body);

      final latestVersion = Version.parse(data['version']);
      final currentVersion = Version.parse(currentAppVersion);

      if (latestVersion > currentVersion) {
        // Show update dialog
        _showUpdateDialog(data['message']);
      } else {
        // Proceed to the main screen or home page
        _navigateToHome();
      }
    } catch (e) {
      // Handle error fetching or parsing update data
      print('Error: $e');
      _navigateToHome();
    }
  }

  void _showUpdateDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Available'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Redirect to the app store or download link for the update
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    // Navigate to the main screen or home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the App!'),
      ),
    );
  }
}
