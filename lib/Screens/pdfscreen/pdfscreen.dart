import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
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

  String getName(int index) {
    return _dashCtrl.allDocuments[index].name;
  }

  final Pdfctlr _pdfctlr = Get.put(Pdfctlr());
  late PDFViewController _pdfViewController;
  String name() {
    String filePath = widget.document.pdfPath;
    String fileName;
    // Use the 'basename' function from the path package to get the filename
    return fileName = basename(filePath);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.document.pdfPath);
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
        actions: <Widget>[
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
      body:
    );
  }
}

// SizedBox(
//   height: double.infinity,
//   width: double.infinity,
// child: SfPdfViewer.file(
//   File(widget.document.pdfPath),
// ),
//   )

// appBar: AppBar(
//   automaticallyImplyLeading: false,
//   leading: IconButton(
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//     icon: Icon(
//       Icons.arrow_back_ios_new,
//       color: AppColor.whiteClr,
//     ),
//   ),
//   backgroundColor: AppColor.themeDark,
//   title: Text(
//     getName(widget.index),
//     style: TextStyle(
//       fontWeight: FontWeight.w500,
//       color: AppColor.whiteClr,
//     ),
//   ),
//   actions: <Widget>[
//     IconButton(
//       icon: Icon(
//         Icons.share,
//         color: AppColor.whiteClr,
//       ),
//       onPressed: () async {
//         _dashCtrl.sharePDF(context, widget.index);
//       },
//     ),
//     IconButton(
//       icon: Icon(
//         Icons.cloud_upload,
//         color: AppColor.whiteClr,
//       ),
//       onPressed: () async {
//         final pdf = File(_dashCtrl.allDocuments[widget.index].pdfPath);
//         await Printing.layoutPdf(
//             onLayout: (context) => pdf.readAsBytesSync());
//       },
//     ),
//   ],
// ),

class Pdfctlr extends GetxController {
  RxBool isDocumentLoaded = false.obs;
}
