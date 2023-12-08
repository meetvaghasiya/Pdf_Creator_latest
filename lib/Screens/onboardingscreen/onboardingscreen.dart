import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboard.dart';
import 'package:pdf_creator/Utilities/classes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: "Let's Go",
      onFinish: () async {
        await _secureStorage.write(key: 'onboarding_status', value: 'finished');
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const DashBoard(),
          ),
        );
      },
      finishButtonStyle: FinishButtonStyle(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: kDarkBlueColor,
      ),
      // trailingFunction: () {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => const HomeScreen(),
      //   ),
      // );
      // },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: Colors.transparent,
      pageBackgroundColor: Colors.transparent,
      background: [
        Image.asset(
          'assets/images/onboardingone.jpg',
          height: 350,
        ),
        Image.asset(
          'assets/images/onboardingtwo.jpg',
          height: 350,
        ),
        Image.asset(
          'assets/images/onboardingthree.png',
          height: 350,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Welcome to PDF Creator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Begin with a warm welcome and introduce users to your PDF creator app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Effortless PDF Creation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Explain how your app simplifies the process and saves users time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Organize and Share Seamlessly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Showcase how your app facilitates organization and sharing of PDF documents.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
