import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentModel {
  String name;
  String documentPath;
  String dateTime;
  String pdfPath;
  List<File> imageList;

  DocumentModel(
      {required this.name,
      required this.documentPath,
      required this.dateTime,
      required this.pdfPath,
      required this.imageList});
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
