import 'dart:async';
import 'dart:io';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf_creator/model/documentmodel.dart';
import 'package:pdf_creator/provider/documentprovider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatefulWidget {
  DocumentModel document;
  var animatedListKey;
  final index;
  PDFScreen({required this.document, this.animatedListKey, this.index});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool isShowDialog = false;

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

  String getName() {
    int lastSlashIndex = widget.document.pdfPath.lastIndexOf('/');

    int dotIndex = widget.document.pdfPath.indexOf('.', lastSlashIndex);
    return widget.document.pdfPath.substring(lastSlashIndex + 1, dotIndex);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.document.pdfPath);
    return Scaffold(
      appBar: AppBar(
        title: Text(getName()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await FlutterShare.shareFile(
                  title: "pdf", filePath: widget.document.pdfPath);
            },
          ),
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              final pdf = File(
                  Provider.of<DocumentProvider>(context, listen: false)
                      .allDocuments[widget.index]
                      .pdfPath);
              await Printing.layoutPdf(
                  onLayout: (context) => pdf.readAsBytesSync());
            },
          ),
        ],
      ),
      body: Container(
        child: SfPdfViewer.file(
          File(widget.document.pdfPath),
        ),
      ),
    );
  }

  // Widget moreSheet(DocumentModel document) {
  //   return SafeArea(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: <Widget>[
  //           Stack(
  //             children: <Widget>[
  //               Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 400,
  //                   child: Image.file(new File(document.documentPath))),
  //               Positioned(
  //                 top: 350,
  //                 child: Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 50,
  //                     color: Colors.black.withOpacity(0.7),
  //                     child: Center(
  //                       child: Text(
  //                         document.name,
  //                         style: TextStyle(color: Colors.white, fontSize: 18),
  //                       ),
  //                     )),
  //               ),
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       isShowDialog = false;
  //                     });
  //                   },
  //                   child: Container(
  //                     margin: EdgeInsets.only(right: 10),
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         color: Colors.black.withOpacity(0.7),
  //                         borderRadius: BorderRadius.circular(30)),
  //                     child: Icon(
  //                       Icons.clear,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.edit),
  //             title: Text("Rename"),
  //             onTap: () {
  //               int? docIndex;
  //               List<DocumentModel> documents =
  //                   Provider.of<DocumentProvider>(context, listen: false)
  //                       .allDocuments;
  //               for (int index = 0; index < documents.length; index++) {
  //                 if (document.dateTime == documents[index].dateTime) {
  //                   docIndex = index;
  //                 }
  //               }
  //               showRenameDialog(
  //                   index: docIndex!,
  //                   dateTime: document.dateTime,
  //                   name: document.name);
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.print),
  //             title: Text("Print"),
  //             onTap: () async {
  //               final pdf = File(document.pdfPath);
  //               await Printing.layoutPdf(
  //                   onLayout: (_) => pdf.readAsBytesSync());
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.delete),
  //             title: Text("Delete"),
  //             onTap: () {
  //               int? docIndex;
  //               List<DocumentModel> documents =
  //                   Provider.of<DocumentProvider>(context, listen: false)
  //                       .allDocuments;
  //               for (int index = 0; index < documents.length; index++) {
  //                 if (document.dateTime == documents[index].dateTime) {
  //                   docIndex = index;
  //                 }
  //               }
  //               showDeleteDialog1(
  //                   index: docIndex!, dateTime: document.dateTime);
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                Provider.of<DocumentProvider>(context, listen: false)
                    .renameDocument(
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
        content: Container(
            child: Column(
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
        )),
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
              Provider.of<DocumentProvider>(context, listen: false)
                  .deleteDocument(
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
