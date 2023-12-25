// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TTSExample extends StatefulWidget {
//   @override
//   State<TTSExample> createState() => _TTSExampleState();
// }

// class _TTSExampleState extends State<TTSExample> {
//   FlutterTts flutterTts = FlutterTts();

//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);

//     await flutterTts.speak(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text-to-Speech Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             speak("Hello, Mr.Denish Gujrati How are You");
//           },
//           child: Text('Speak'),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           speak("Hello, Mr.Denish Gujrati How are You");
//         },
//         child: Icon(Icons.mic),
//       ),
//     );
//   }
// }
