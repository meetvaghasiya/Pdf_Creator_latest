import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextSpeechScreen extends StatefulWidget {
  final List<String> extractedTextList;

  const TextSpeechScreen({Key? key, required this.extractedTextList})
      : super(key: key);

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
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> showTextSelectionDialog() async {
    String? selectedText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.extractedTextList.length, (index) {
              final selectindex = index + 1;
              return ListTile(
                title: Text(
                  "Text ${selectindex.toString()}",
                ),
                onTap: () {
                  Navigator.pop(context, widget.extractedTextList[index]);
                },
              );
            }),
          ),
        );
      },
    );

    if (selectedText != null) {
      speak(selectedText);
      setState(() {
        this.selectedText = selectedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("voice ${widget.extractedTextList.toString()}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Text Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (selectedText.isNotEmpty)
              ListTile(
                title: SelectableText(selectedText),
              )
            else
              for (var text in widget.extractedTextList)
                ListTile(
                  title: SelectableText(text),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isSpeaking) {
            stopSpeaking();
          } else {
            showTextSelectionDialog();
          }
        },
        child: Icon(isSpeaking ? Icons.stop : Icons.mic),
      ),
    );
  }
}
