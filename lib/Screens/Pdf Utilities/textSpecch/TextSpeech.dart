import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Utilities/colors.dart';

class TextSpeechScreen extends StatefulWidget {
  final List<String> extractedTextList;
  final String pdfname;

  const TextSpeechScreen(
      {super.key, required this.extractedTextList, required this.pdfname});

  @override
  State<TextSpeechScreen> createState() => _TextSpeechScreenState();
}

class _TextSpeechScreenState extends State<TextSpeechScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  String selectedText = '';

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    await flutterTts.speak(text);

    setState(() {
      isSpeaking = true;
    });

    // Register an onComplete callback to automatically stop when speech is complete
    flutterTts.setCompletionHandler(() {
      stopSpeaking();
    });
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> showTextSelectionDialog() async {
    // Stop the current speech if it is ongoing
    if (isSpeaking) {
      stopSpeaking();
    }

    String? selectedText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add the "All Text" option
              ListTile(
                title: Text("All Text"),
                onTap: () {
                  Navigator.pop(context, widget.extractedTextList.join(' '));
                },
              ),
              // Generate the list of extracted text
              ...List.generate(widget.extractedTextList.length, (index) {
                final selectindex = index + 1;
                return ListTile(
                  title: Text("Text ${selectindex.toString()}"),
                  onTap: () {
                    Navigator.pop(context, widget.extractedTextList[index]);
                  },
                );
              }),
            ],
          ),
        );
      },
    );

    if (selectedText != null) {
      setState(() {
        this.selectedText = selectedText;
      });
      speak(selectedText);
    }
  }

  @override
  void dispose() {
    // Stop speech when the state is disposed (e.g., when the user goes back)
    stopSpeaking();

    // Unregister the completion handler
    flutterTts.setCompletionHandler(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("voice ${widget.extractedTextList.toString()}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.themeDark,
        title: Text(
          widget.pdfname,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showTextSelectionDialog();
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount:
            selectedText.isNotEmpty ? 1 : widget.extractedTextList.length,
        itemBuilder: (context, index) {
          final text = selectedText.isNotEmpty
              ? selectedText
              : widget.extractedTextList[index];

          return ListTile(
            title: SelectableText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: selectedText.isNotEmpty
                        ? "Selected Text : "
                        : "Text ${index + 1} : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeDark,
        onPressed: () {
          if (isSpeaking) {
            stopSpeaking();
          } else {
            if (widget.extractedTextList.toString().isNotEmpty) {
              speak(widget.extractedTextList.toString());
              if (selectedText.isNotEmpty) {
                speak(selectedText);
              }
            }
          }
        },
        child: Icon(
          isSpeaking ? Icons.stop : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
