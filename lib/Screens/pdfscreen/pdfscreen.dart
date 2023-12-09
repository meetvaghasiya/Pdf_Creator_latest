import 'dart:io';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:printing/printing.dart';
import '../../Utilities/classes.dart';
import '../DashBoard Screen/dashboardCtrl.dart';

// ignore: must_be_immutable
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
  PDFDocument? doc;
  load() async {
    doc = await PDFDocument.fromFile(File(widget.document.pdfPath));
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  String getName(int index) {
    return _dashCtrl.allDocuments[index].name;
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
      body: Center(
        child: doc != null
            ? PDFViewer(
                document: doc!,
                pickerButtonColor: AppColor.themeDark,
                lazyLoad: false,
                navigationBuilder:
                    (context, page, totalPages, jumpToPage, animateToPage) {
                  return Container(
                    height: Get.height * .07,
                    decoration: BoxDecoration(
                        color: AppColor.themeDark.withOpacity(.8)),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.first_page,
                            color: AppColor.whiteClr,
                          ),
                          onPressed: () {
                            jumpToPage(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColor.whiteClr,
                          ),
                          onPressed: () {
                            animateToPage(page: page! - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: AppColor.whiteClr,
                          ),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.last_page,
                            color: AppColor.whiteClr,
                          ),
                          onPressed: () {
                            jumpToPage(page: totalPages! - 1);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : CircularProgressIndicator(color: AppColor.themeDark),
      ),
    );
  }
}
