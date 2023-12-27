import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
import 'package:pdf_creator/Screens/Pdf%20Utilities/textSpecch/TextSpeech.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfctrl.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:printing/printing.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final PdfCtrl pdfController = Get.put(PdfCtrl());
  final DashCtrl _dashCtrl = Get.put(DashCtrl());
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.themeDark,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.whiteClr,
          ),
        ),
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => pdfController.bookmarks.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final bookmarkPage = pdfController.bookmarks[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: buildDocumentCard(bookmarkPage, context),
                  );
                },
                itemCount: pdfController.bookmarks.length,
              )
            : Center(
                child: Text("No Bookmarks Found!"),
              ),
      ),
    );
  }

  Widget buildDocumentCard(
    int index,
    context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFScreen(
            index: index,
            document: _dashCtrl.allDocuments[index],
            animatedListKey: animatedListKey,
          ),
        ));
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              stops: [.25, .42],
              colors: [AppColor.themeDark.withOpacity(.6), AppColor.themeDark],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        left: BorderSide(color: Colors.grey[300]!),
                        right: BorderSide(color: Colors.grey[300]!),
                        top: BorderSide(color: Colors.grey[300]!),
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(_dashCtrl.allDocuments[index].documentPath),
                        height: 150,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _dashCtrl.allDocuments[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        // "${formattedDate} ${formattedTime}",
                        _dashCtrl.allDocuments[index].dateTime,
                        style: TextStyle(color: AppColor.whiteClr),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .6,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: AppColor.whiteClr,
                                ),
                                onPressed: () {
                                  _dashCtrl.sharePDF(context, index);
                                }),
                            IconButton(
                              icon: Icon(
                                Icons.cloud_upload,
                                color: AppColor.whiteClr,
                              ),
                              onPressed: () async {
                                final pdf =
                                    File(_dashCtrl.allDocuments[index].pdfPath);
                                await Printing.layoutPdf(
                                    onLayout: (context) =>
                                        pdf.readAsBytesSync());
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: AppColor.whiteClr,
                                ),
                                onPressed: () {
                                  showModalSheet(
                                      index: index,
                                      filePath: _dashCtrl
                                          .allDocuments[index].documentPath,
                                      dateTime: _dashCtrl
                                          .allDocuments[index].dateTime
                                          .toString(),
                                      context: context,
                                      name: _dashCtrl.allDocuments[index].name,
                                      pdfPath: _dashCtrl
                                          .allDocuments[index].pdfPath);
                                })
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRenameDialog({int? index, String? dateTime, String? name, context}) {
    TextEditingController controller = TextEditingController();
    controller.text = name!;
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Rename"),
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                  suffix: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                      })),
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel")),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _dashCtrl.allDocuments[index!].name = controller.text;
                });
                _dashCtrl.renameDocument(
                    index!, dateTime.toString(), controller.text);
              },
              child: Text("Rename")),
        ],
      ),
    );
  }

  void showModalSheet({
    int? index,
    String? filePath,
    String? name,
    String? dateTime,
    BuildContext? context,
    String? pdfPath,
    // PDFDoc? pdfDoc,
  }) {
    // final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    showModalBottomSheet(
      context: context!,
      builder: (context) {
        return Container(
          color: AppColor.themeDark,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width * .17,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(filePath!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(left: 12, bottom: 12),
                        child: Text(
                          name!,
                          style: TextStyle(
                              color: AppColor.whiteClr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            _dashCtrl.allDocuments[index!].dateTime,
                            style: TextStyle(
                              color: AppColor.whiteClr,
                            ),
                          )),
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: AppColor.greyClr,
              ),
              ListTile(
                  leading: Icon(
                    Icons.edit_document,
                    color: AppColor.whiteClr,
                  ),
                  title: Text(
                    "PDF To Text",
                    style: TextStyle(
                      color: AppColor.whiteClr,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    List<String> filePaths = _dashCtrl
                        .allDocuments[index].imageList
                        .map((e) => e.path)
                        .toList();
                    List<String> extractedTextList = [];

                    for (String filePath in filePaths) {
                      final inputImage = InputImage.fromFile(File(filePath));
                      final textRecognizer =
                          GoogleMlKit.vision.textRecognizer();
                      final recognisedText =
                          await textRecognizer.processImage(inputImage);

                      if (recognisedText.text.isNotEmpty) {
                        extractedTextList.add(recognisedText.text);
                      }

                      textRecognizer.close();
                    }

// Check if there is at least one non-empty text before navigating to TextSpeechScreen
                    if (extractedTextList.isNotEmpty) {
                      // Assuming you have a StatefulWidget, update the state to trigger a rebuild
                      setState(() {});

                      // Navigate to the new screen and pass the list of extracted texts
                      Get.to(() => TextSpeechScreen(
                            extractedTextList: extractedTextList,
                            pdfname: name,
                          ));
                    } else {
                      // Handle the case when there is no non-empty text, e.g., show a message or take other actions.
                    }
                  }),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColor.whiteClr,
                ),
                title: Text(
                  "Rename",
                  style: TextStyle(
                    color: AppColor.whiteClr,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showRenameDialog(
                      index: index,
                      name: name,
                      dateTime: dateTime,
                      context: context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: AppColor.whiteClr,
                ),
                title: Text(
                  "Delete",
                  style: TextStyle(
                    color: AppColor.whiteClr,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteDialog1(
                    index: index,
                    dateTime: dateTime,
                    context: context,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void showDeleteDialog1({int? index, String? dateTime, context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Delete file",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 2,
            ),
            Text(
              "Are you sure you want to delete this file?",
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();

              _dashCtrl.deleteDocument(index!, dateTime.toString().toString());
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
