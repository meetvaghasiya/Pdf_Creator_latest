import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../provider/documentprovider.dart';

Future<void> abcsharePDF(context, int index) async {
  // Replace 'your_pdf_file.pdf' with the actual path to your PDF file
  String pdfPath = Provider.of<DocumentProvider>(context, listen: false)
      .allDocuments[index]
      .pdfPath;

  // Check if the PDF file exists
  if (await File(pdfPath).exists()) {
    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create a copy of the PDF file in the temporary directory
    File tempPDF = File(
        '${tempDir.path}/${Provider.of<DocumentProvider>(context, listen: false).allDocuments[index].name}.pdf');
    await File(pdfPath).copy(tempPDF.path);

    // Share the PDF file
    await Share.shareFiles([tempPDF.path], text: 'Sharing PDF File');
  } else {
    print('PDF file does not exist.');
  }
}

// Provider.of<DocumentProvider>(context)
// .allDocuments[index]
// .name,
