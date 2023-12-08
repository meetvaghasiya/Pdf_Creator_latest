import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class DocumentModel {
  String name;
  String shareLink;
  String documentPath;
  DateTime dateTime;
  String pdfPath;
  DocumentModel(
      {required this.name,
      this.shareLink = "",
      required this.documentPath,
      required this.dateTime,
      required this.pdfPath});
}
