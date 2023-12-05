import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/model/documentmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentProvider extends ChangeNotifier {
  List<DocumentModel> allDocuments = [];

  Future<bool> getDocuments() async {
    print("asdasfadfadf");
    allDocuments = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getKeys().forEach((key) {
      var jsonDocument = json.decode(sharedPreferences.getString(key)!);
      DocumentModel document = DocumentModel(
          name: jsonDocument['name'],
          documentPath: jsonDocument['documentPath'],
          dateTime: DateTime.parse(jsonDocument['dateTime']),
          pdfPath: jsonDocument['pdfPath'],
          shareLink: jsonDocument['shareLink']);
      allDocuments.add(document);
    });
    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    DocumentModel document = DocumentModel(
        name: "",
        documentPath: "",
        dateTime: DateTime.utc(1969, 7, 20, 20, 18, 04),
        pdfPath: "",
        shareLink: "");
    allDocuments.add(document);
    notifyListeners();
    return true;
  }

  void saveDocument({
    required String name,
    required String documentPath,
    required DateTime dateTime,
    required String shareLink,
    required GlobalKey<AnimatedListState> animatedListKey,
  }) async {
    final pdf = pw.Document();
    final image = File(documentPath).readAsBytesSync();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(2480, 3508),
      build: (pw.Context context) {
        return pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.fitWidth);
      },
    ));
    final tempDir = await getApplicationDocumentsDirectory();
    String pdfPath = "${tempDir.path}/$name.pdf";
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());
    DocumentModel document = DocumentModel(
        name: name,
        documentPath: documentPath,
        dateTime: dateTime,
        pdfPath: pdfPath,
        shareLink: shareLink);

    String jsonDocument = json.encode({
      "name": document.name,
      "documentPath": document.documentPath,
      "dateTime": document.dateTime.toString(),
      "shareLink": document.shareLink,
      "pdfPath": document.pdfPath
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        document.dateTime.millisecondsSinceEpoch.toString(), jsonDocument);
    allDocuments.add(document);
    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    Timer(const Duration(milliseconds: 500), () {
      animatedListKey.currentState?.insertItem(0);
      notifyListeners();
    });
  }

  void deleteDocument(int index, String key) async {
    Timer(Duration(milliseconds: 300), () {
      allDocuments.removeAt(index);
      notifyListeners();
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  void renameDocument(int index, String key, String changedName) async {
    allDocuments[index].name = changedName;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);

    String jsonDocument = json.encode({
      "name": allDocuments[index].name,
      "documentPath": allDocuments[index].documentPath,
      "dateTime": allDocuments[index].dateTime.toString(),
      "shareLink": allDocuments[index].shareLink,
      "pdfPath": allDocuments[index].pdfPath
    });
    await sharedPreferences.setString(key, jsonDocument);
    Timer(Duration(milliseconds: 800), () {
      notifyListeners();
    });
  }
}
