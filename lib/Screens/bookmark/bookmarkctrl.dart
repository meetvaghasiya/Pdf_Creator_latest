// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
// import 'dart:convert';
//
// import '../../Utilities/classes.dart';
//
// class BookmarkCtrl extends GetxController {
//   final GetStorage box = GetStorage();
//   RxList<DocumentModel> bookmarks = <DocumentModel>[].obs;
//   final DashCtrl _dashCtrl = Get.put(DashCtrl());
//
//   bool isBookmarked(DocumentModel pdf) {
//     return bookmarks.any((bookmark) => bookmark.name == pdf.name);
//   }
//
//
//   void loadBookmarks() {
//     // List<dynamic>? storedBookmarks = box.read('bookmarks');
//     // if (storedBookmarks != null) {
//     //   bookmarks.assignAll(
//     //     (storedBookmarks)
//     //         .map((json)  {
//     //           print(json);
//     //           return DocumentModel.fromJson(json);})
//     //         .toList(),
//     //   );
//     bookmarks.value = _dashCtrl.allDocuments.where((p0) => p0.isBookmark).toList();
//     print(bookmarks);
//     }
// }


import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../../Utilities/classes.dart';

class BookmarkCtrl extends GetxController {
  final GetStorage box = GetStorage();
  RxList<DocumentModel> bookmarks = <DocumentModel>[].obs;

  bool isBookmarked(DocumentModel pdf) {
    return bookmarks.any((bookmark) => bookmark.name == pdf.name);
  }

  void toggleBookmark(DocumentModel pdf) {
    if (isBookmarked(pdf)) {
      // Remove bookmark
      bookmarks.removeWhere((bookmark) => bookmark.name == pdf.name);
    } else {
      // Add bookmark
      bookmarks.add(pdf);
    }
    // Save bookmarks to GetStorage
    saveBookmarks();
  }

  void saveBookmarks() {
    box.write('bookmarks', bookmarks.map((bookmark) => bookmark.toJson()).toList());
  }

  void loadBookmarks() {
    List<dynamic>? storedBookmarks = box.read('bookmarks');
    if (storedBookmarks != null) {
      bookmarks.assignAll(
        storedBookmarks.map((json) => DocumentModel.fromJson(json)).toList(),
      );
    }
  }
}
