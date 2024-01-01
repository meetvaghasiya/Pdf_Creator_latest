import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentModel {
  late String name;
  late String documentPath;
  late String dateTime;
  late String pdfPath;
  late List<File> imageList;
  late bool isBookmark;

  DocumentModel(
      {required this.name,
      required this.documentPath,
      required this.dateTime,
      required this.pdfPath,
      this.isBookmark = false,
      required this.imageList});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    documentPath = json['documentPath'];
    dateTime = json['dateTime'];
    pdfPath = json['pdfPath'];
    isBookmark = json['isBookmark'];
    imageList =
        (json['imageList'] as List<dynamic>).map<File>((e) => File(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'documentPath': documentPath,
      'dateTime': dateTime,
      'isBookmark': isBookmark,
      'pdfPath': pdfPath,
      'imageList': imageList.map((e) => e.path.toString()).toList()
    };
  }
}

class getCamera {
  static const MethodChannel _channel =
      MethodChannel('cunning_document_scanner');

  /// Call this to start get Picture workflow.
  static Future<List<String>?> getPictures(bool crop) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) ||
        statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    final List<dynamic>? pictures =
        await _channel.invokeMethod('getPictures', {'crop': crop});

    return pictures?.map((e) => e as String).toList();
  }
}
