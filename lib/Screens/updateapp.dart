import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}



class _UpdateAppScreenState extends State<UpdateAppScreen> {

  // void _showUpdateDialog(String message) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => WillPopScope(
  //       onWillPop: () {
  //         exit(0);
  //       },
  //       child: AlertDialog(
  //         title: Text('Update Available'),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               _launchStoreLink();
  //               Get.back();
  //             },
  //             child: Text('Update Now'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _launchStoreLink() async {
    // Replace the URLs with your app's actual Play Store and App Store links
    String playStoreLink =
        'https://play.google.com/store/apps/details?id=com.pdf.creator.apps';
    String appStoreLink =
        'https://apps.apple.com/in/app/pdf-creator-app/id6475385314';

    // Choose the appropriate link based on the platform
    String storeLink = Platform.isAndroid ? playStoreLink : appStoreLink;

    if (await canLaunchUrlString(storeLink)) {
      await launchUrlString(storeLink);
    } else {
      // Handle error
      print('Could not launch store link');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: SvgPicture.asset("assets/images/Update.svg"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Text(
            "A New Version of PDF Creator App Is Now Available. Please Update App To Latest Version.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          ElevatedButton(
            onPressed: () {
              _launchStoreLink();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Set your desired color here
            ),
            child: Text("Update Now",style: TextStyle(color: Colors.white),),
          ),

        ],
      ),
    );
  }
}
