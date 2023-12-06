import 'dart:async';
import 'dart:io';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Utilities/classes.dart';
import '../DashBoard Screen/dashboardCtrl.dart';

class PDFScreen extends StatefulWidget {
  DocumentModel document;
  var animatedListKey;
  final index;
  PDFScreen(
      {super.key, required this.document, this.animatedListKey, this.index});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool isShowDialog = false;
  final DashCtrl _dashCtrl = Get.put(DashCtrl());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isShowDialog) {
      setState(() {
        isShowDialog = false;
      });
    } else {
      Navigator.of(context).pop();
    }
    return true;
  }

  String getName(int index) {
    return _dashCtrl.allDocuments[index].name;
    // int lastSlashIndex = widget.document.pdfPath.lastIndexOf('/');
    //
    // int dotIndex = widget.document.pdfPath.indexOf('.', lastSlashIndex);
    // return widget.document.pdfPath.substring(lastSlashIndex + 1, dotIndex);
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SfPdfViewer.file(
          File(widget.document.pdfPath),
        ),
      ),
    );
  }

  void showRenameDialog({int? index, DateTime? dateTime, String? name}) {
    TextEditingController controller = TextEditingController();
    controller.text = name!;
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
            child: Column(
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
        )),
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
                  widget.document.name = controller.text;
                });
                _dashCtrl.renameDocument(
                    index!,
                    dateTime!.millisecondsSinceEpoch.toString(),
                    controller.text);
              },
              child: Text("Rename")),
        ],
      ),
    );
  }

  void showDeleteDialog1({int? index, DateTime? dateTime}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Delete file",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
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
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              _dashCtrl.deleteDocument(
                  index!, dateTime!.millisecondsSinceEpoch.toString());
              Timer(Duration(milliseconds: 300), () {
                widget.animatedListKey.currentState
                    .removeItem(index, (context, animation) => SizedBox());
              });
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
