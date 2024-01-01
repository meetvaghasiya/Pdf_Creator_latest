import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
import 'package:pdf_creator/Screens/Pdf%20Utilities/textSpecch/TextSpeech.dart';
import 'package:pdf_creator/Screens/bookmark/bookmarkctrl.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';
import 'package:pdf_creator/Utilities/classes.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:pdf_creator/Utilities/utilities.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';

class BookmarkScreen extends StatefulWidget {
  final int dashindex;
  const BookmarkScreen({super.key, required this.dashindex});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkCtrl _bookmarkCtrl = Get.put(BookmarkCtrl());
  final DashCtrl _dashCtrl = Get.put(DashCtrl());
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
@override
  void initState() {
    _bookmarkCtrl.loadBookmarks();
    super.initState();
  }
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
        () => _bookmarkCtrl.bookmarks.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentModel bookmarkPage = _bookmarkCtrl.bookmarks[index];

                  return Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PDFScreen(
                              index: widget.dashindex,
                              document: bookmarkPage,
                              animatedListKey: animatedListKey,
                            ),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              stops: [.25, .42],
                              colors: [
                                AppColor.themeDark.withOpacity(.6),
                                AppColor.themeDark
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, left: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.grey[300]!),
                                        right: BorderSide(
                                            color: Colors.grey[300]!),
                                        top: BorderSide(
                                            color: Colors.grey[300]!),
                                        bottom: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        File(_bookmarkCtrl.bookmarks[index]
                                            .imageList[0].path),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.all(12),
                                      child: Obx(
                                        () => Text(
                                          (_dashCtrl.allDocuments[widget.dashindex].name),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        // "${formattedDate} ${formattedTime}",
                                        (_bookmarkCtrl
                                            .bookmarks[index].dateTime),
                                        style:
                                            TextStyle(color: AppColor.whiteClr),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(
                                                  Icons.share,
                                                  color: AppColor.whiteClr,
                                                ),
                                                onPressed: () async {
                                                  String pdfPath = _bookmarkCtrl
                                                      .bookmarks[index].pdfPath;
                                                  if (await File(pdfPath)
                                                      .exists()) {
                                                    Directory tempDir =
                                                        await getTemporaryDirectory();
                                                    File tempPDF = File(
                                                        '${tempDir.path}/${_bookmarkCtrl.bookmarks[index].name}.pdf');
                                                    await File(pdfPath)
                                                        .copy(tempPDF.path);
                                                    await Share.shareFiles(
                                                        [tempPDF.path],
                                                        text:
                                                            'Sharing PDF File');
                                                  }
                                                }),
                                            IconButton(
                                              icon: Icon(
                                                Icons.cloud_upload,
                                                color: AppColor.whiteClr,
                                              ),
                                              onPressed: () async {
                                                final pdf = File(_bookmarkCtrl
                                                    .bookmarks[index].pdfPath);
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
                                                      file: _bookmarkCtrl
                                                          .bookmarks[index]
                                                          .documentPath,
                                                      filePath: _bookmarkCtrl
                                                          .bookmarks[index]
                                                          .imageList[0]
                                                          .path,
                                                      dateTime: _bookmarkCtrl
                                                          .bookmarks[index]
                                                          .dateTime
                                                          .toString(),
                                                      context: context,
                                                      name: _bookmarkCtrl
                                                          .bookmarks[index]
                                                          .name,
                                                      pdfPath: _bookmarkCtrl
                                                          .bookmarks[index]
                                                          .pdfPath);
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
                    ),
                  );
                },
                itemCount: _bookmarkCtrl.bookmarks.length,
              )
            : Center(
                child: Text("No Bookmarks Found!"),
              ),
      ),
    );
  }

  void showRenameDialog({int? index, String? dateTime, String? name, context}) {
    // TextEditingController controller = TextEditingController();
    _dashCtrl.nameEditcontroller.text = name!;
    _dashCtrl.nameEditcontroller.selection =
        TextSelection(baseOffset: 0, extentOffset:  _dashCtrl.nameEditcontroller.text.length);
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
              controller:  _dashCtrl.nameEditcontroller,
              autofocus: true,
              decoration: InputDecoration(
                  suffix: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _dashCtrl.nameEditcontroller.clear();
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
                _dashCtrl.renameDocument(
                    widget.dashindex, dateTime.toString(),  _dashCtrl.nameEditcontroller.text);
              },
              child: Text("Rename")),
        ],
      ),
    );
  }

  void showModalSheet({
    int? index,
    String? filePath,
    file,
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
                            dateTime!,
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
                  Icons.download,
                  color: AppColor.whiteClr,
                ),
                title: Text(
                  "Save All Images",
                  style: TextStyle(
                    color: AppColor.whiteClr,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  List imagePaths =
                      (_bookmarkCtrl.bookmarks[index!].imageList).toList();

                  LoadingDialog.show(context);

                  for (File imagePath in imagePaths) {
                    await GallerySaver.saveImage(imagePath.path);
                  }

                  LoadingDialog.hide(Get.context!);
                },
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
                    List filePaths =
                        _bookmarkCtrl.bookmarks[index!].imageList.toList();

                    List<String> extractedTextList = [];

                    // Show loading dialog
                    LoadingDialog.show(Get.context!);

                    for (File filePath in filePaths) {
                      final inputImage =
                          InputImage.fromFile(File(filePath.path));
                      final textRecognizer =
                          GoogleMlKit.vision.textRecognizer();
                      final recognisedText =
                          await textRecognizer.processImage(inputImage);

                      if (recognisedText.text.isNotEmpty) {
                        extractedTextList.add(recognisedText.text);
                      }

                      textRecognizer.close();
                    }

                    // Hide loading dialog
                    LoadingDialog.hide(Get.context!);

                    // Check if there is at least one non-empty text before navigating to TextSpeechScreen
                    if (extractedTextList.isNotEmpty) {
                      // Navigate to the new screen and pass the list of extracted texts
                      Get.to(() => TextSpeechScreen(
                            extractedTextList: extractedTextList,
                            pdfname: name,
                          ));
                    } else {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text('Text not found!'),
                          duration: Duration(
                              seconds: 2), // Adjust the duration as needed
                        ),
                      );
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
              // ListTile(
              //   leading: Icon(
              //     Icons.delete,
              //     color: AppColor.whiteClr,
              //   ),
              //   title: Text(
              //     "Delete",
              //     style: TextStyle(
              //       color: AppColor.whiteClr,
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     showDeleteDialog1(
              //       index: index,
              //       dateTime: dateTime,
              //       context: context,
              //     );
              //   },
              // )
            ],
          ),
        );
      },
    );
  }

  // void showDeleteDialog1({int? index, String? dateTime, context}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           const Text(
  //             "Delete file",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const Divider(
  //             thickness: 2,
  //           ),
  //           Text(
  //             "Are you sure you want to delete this file?",
  //             style: TextStyle(color: Colors.grey[500]),
  //           )
  //         ],
  //       ),
  //       actions: <Widget>[
  //         MaterialButton(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text(
  //             "Cancel",
  //             style: TextStyle(color: Colors.black),
  //           ),
  //         ),
  //         MaterialButton(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //
  //             _dashCtrl.deleteDocument(index!, dateTime.toString());
  //           },
  //           child: const Text(
  //             "Delete",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
