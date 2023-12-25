import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  String getName(int index) {
    return _dashCtrl.allDocuments[index].name;
  }

  @override
  Widget build(BuildContext context) {
    print("==>${widget.document.pdfPath}");
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
      body: Stack(
        children: [
          PDFView(
            filePath: widget.document.pdfPath,
            enableSwipe: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: false,
            fitEachPage: false,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {
              setState(() {
                pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text("${errorMessage}"),
                )
        ],
      ),
      floatingActionButton: currentPage == 0
          ? null
          : FutureBuilder<PDFViewController>(
              future: _controller.future,
              builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
                if (snapshot.hasData) {
                  return FloatingActionButton.extended(
                    label: Icon(Icons.arrow_upward_rounded),
                    onPressed: () async {
                      await snapshot.data!.setPage(pages! ~/ 2);
                    },
                  );
                }
                return Container();
              },
            ),
    );
  }
}
