import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_creator/Utilities/utilities.dart';
import 'package:share/share.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Utilities/classes.dart';

class DashCtrl extends GetxController {
  RxBool nameIsValid = true.obs;
  RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  RxBool isLoading = false.obs;
  final GetStorage box = GetStorage();

  Future<void> sharePDF(context, int index) async {
    String pdfPath = allDocuments[index].pdfPath;
    if (await File(pdfPath).exists()) {
      Directory tempDir = await getTemporaryDirectory();
      File tempPDF = File('${tempDir.path}/${allDocuments[index].name}.pdf');
      await File(pdfPath).copy(tempPDF.path);
      await Share.shareFiles([tempPDF.path], text: 'Sharing PDF File');
    }
  }

  Future getDocuments() async {
    isLoading.value = true;
    allDocuments = <DocumentModel>[].obs;
    box.getKeys().forEach((key) {
      var jsonDocument = json.decode(box.read(key) ?? '{}');
      DocumentModel document = DocumentModel(
        name: jsonDocument['name'],
        documentPath: jsonDocument['documentPath'],
        dateTime: jsonDocument['dateTime'],
        pdfPath: jsonDocument['pdfPath'],
      );
      allDocuments.add(document);
    });

    allDocuments.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });
    isLoading.value = false;
    return true;
  }

  Future<void> showRenameDialog(List imagePaths, context, isGallery) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    nameController.value.clear();

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generate PDF'),
          content: Form(
            key: formKey,
            child: Obx(
              () => TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter PDF Name";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter Name"),
                style: const TextStyle(color: Colors.black, fontSize: 20),
                controller: nameController.value,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                  String formattedTime =
                      DateFormat('hh:mm:ss a').format(DateTime.now());
                  List<File>? imageFiles;
                  if (!isGallery) {
                    imageFiles = imagePaths.map((path) => File(path)).toList();
                  } else {
                    imageFiles = imagePaths.cast<File>();
                  }
                  await saveDocument(
                    imageList: imageFiles,
                    name: nameController.value.text.trim(),
                    documentPath: imageFiles[0].path,
                    dateTime: '$formattedDate $formattedTime',
                  );
                }
              },
              child: const Text('Create PDF'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDocument({
    required String name,
    required documentPath,
    required List<File> imageList,
    required dateTime,
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
      );

      String jsonDocument = json.encode({
        "name": document.name,
        "documentPath": document.documentPath,
        "dateTime": document.dateTime.toString(),
        "pdfPath": document.pdfPath,
      });
      box.write(document.dateTime.toString(), jsonDocument);

      allDocuments.add(document);
      allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));

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
      "pdfPath": allDocuments[index].pdfPath,
    });
    box.write(key, jsonDocument);

    Timer(Duration(milliseconds: 800), () {});
  }
}
