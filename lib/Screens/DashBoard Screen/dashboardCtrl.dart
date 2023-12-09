import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share/share.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Utilities/classes.dart';

class DashCtrl extends GetxController {
  RxBool nameIsValid = true.obs;
  RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;

  final GetStorage box = GetStorage();

  Future<void> sharePDF(context, int index) async {
    String pdfPath = allDocuments[index].pdfPath;

    // Check if the PDF file exists
    if (await File(pdfPath).exists()) {
      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();

      // Create a copy of the PDF file in the temporary directory
      File tempPDF = File('${tempDir.path}/${allDocuments[index].name}.pdf');
      await File(pdfPath).copy(tempPDF.path);

      // Share the PDF file
      await Share.shareFiles([tempPDF.path], text: 'Sharing PDF File');
    }
  }

  Future getDocuments() async {
    allDocuments = <DocumentModel>[].obs;

    box.getKeys().forEach((key) {
      var jsonDocument = json.decode(box.read(key) ?? '{}');
      DocumentModel document = DocumentModel(
        name: jsonDocument['name'],
        documentPath: jsonDocument['documentPath'],
        dateTime: DateTime.parse(jsonDocument['dateTime']),
        pdfPath: jsonDocument['pdfPath'],
        shareLink: jsonDocument['shareLink'],
      );
      allDocuments.add(document);
    });

    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return true;
  }

  void saveDocument({
    required String name,
    required documentPath,
    required List imageList,
    required DateTime dateTime,
    required String shareLink,
    required GlobalKey<AnimatedListState> animatedListKey,
  }) async {
    final pdf = pw.Document();
    for (var img in imageList) {
      final image = img.readAsBytesSync();
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(2480, 3508),
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.fitWidth);
        },
      ));
    }

    final tempDir = await getApplicationDocumentsDirectory();
    String pdfPath = "${tempDir.path}/$name.pdf";
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());

    DocumentModel document = DocumentModel(
      name: name,
      documentPath: documentPath,
      dateTime: dateTime,
      pdfPath: pdfPath,
      shareLink: shareLink,
    );

    String jsonDocument = json.encode({
      "name": document.name,
      "documentPath": document.documentPath,
      "dateTime": document.dateTime.toString(),
      "shareLink": document.shareLink,
      "pdfPath": document.pdfPath,
    });
    box.write(
        document.dateTime.millisecondsSinceEpoch.toString(), jsonDocument);

    allDocuments.add(document);
    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    Timer(const Duration(milliseconds: 500), () {
      animatedListKey.currentState?.insertItem(0);
    });
  }

  void deleteDocument(int index, String key) async {
    Timer(Duration(milliseconds: 300), () {
      allDocuments.removeAt(index);
    });

    box.remove(key);
  }

  void renameDocument(int index, String key, String changedName) async {
    box.remove(key);

    allDocuments[index].name = changedName;
    String jsonDocument = json.encode({
      "name": changedName,
      "documentPath": allDocuments[index].documentPath,
      "dateTime": allDocuments[index].dateTime.toString(),
      "shareLink": allDocuments[index].shareLink,
      "pdfPath": allDocuments[index].pdfPath,
    });
    box.write(key, jsonDocument);

    Timer(Duration(milliseconds: 800), () {});
  }
}
