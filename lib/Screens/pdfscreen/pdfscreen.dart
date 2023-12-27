import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfctrl.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printing/printing.dart';

import '../../Utilities/classes.dart';
import '../DashBoard Screen/dashboardCtrl.dart';

class PDFScreen extends StatefulWidget {
  DocumentModel document;
  var animatedListKey;
  final index;
  PDFScreen({
    super.key,
    required this.document,
    this.animatedListKey,
    this.index,
  });

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final DashCtrl _dashCtrl = Get.put(DashCtrl());
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  String getName(int index) {
    return _dashCtrl.allDocuments[index].name;
  }

  final PdfCtrl pdfController = Get.put(PdfCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.whiteClr,
          ),
        ),
        backgroundColor: AppColor.themeDark,
        title: Text(
          getName(widget.index),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.whiteClr,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: pdfController.isBookmarked(widget.index)
                  ? Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,
                    ),
              onPressed: () {
                final isBookmarked = pdfController.isBookmarked(widget.index);
                final message = isBookmarked
                    ? 'Removed bookmark for ${getName(widget.index)}'
                    : 'Saved bookmark for ${getName(widget.index)}';

                // Toggle the bookmark
                pdfController.toggleBookmark(widget.index);

                // Show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration:
                        Duration(seconds: 2), // Adjust the duration as needed
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: AppColor.whiteClr,
            ),
            onPressed: () async {
              _dashCtrl.sharePDF(context, widget.index);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.cloud_upload,
              color: AppColor.whiteClr,
            ),
            onPressed: () async {
              final pdf = File(_dashCtrl.allDocuments[widget.index].pdfPath);
              await Printing.layoutPdf(
                  onLayout: (context) => pdf.readAsBytesSync());
            },
          ),
        ],
      ),
      body: PdfViewer.openFile(widget.document.pdfPath),
      // Stack(
      //   children: [
      //     errorMessage.isEmpty
      //         ? !isReady
      //             ? Center(
      //                 child: CircularProgressIndicator(),
      //               )
      //             : Container()
      //         : Center(
      //             child: Text("Error: $errorMessage"),
      //           )
      //   ],
      // ),
    );
  }
}
