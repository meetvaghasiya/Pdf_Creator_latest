import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Utilities/classes.dart';

class BookmarkCtrl extends GetxController {
  final GetStorage box = GetStorage();
  RxList<DocumentModel> bookmarks = <DocumentModel>[].obs;

  @override
  void onInit() {
    loadBookmarks();
    super.onInit();
  }

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

  void renameDocument(DocumentModel document, String key, String newName) {
    int index = bookmarks.indexWhere((bookmark) => bookmark.name == document.name);

    if (index != -1) {
      bookmarks[index].name = newName;

      // Save bookmarks to GetStorage
      saveBookmarks();

      // Notify the UI about the change
      update(bookmarks);
    }
  }

  void saveBookmarks() {
    box.write('bookmarks', bookmarks.map((bookmark) => bookmark.toJson()).toList());
  }

  // Load bookmarks from GetStorage (optional)
  void loadBookmarks() {
    List<dynamic>? storedBookmarks = box.read('bookmarks');
    if (storedBookmarks != null) {
      bookmarks.assignAll(
        storedBookmarks.map((json) => DocumentModel.fromJson(json)).toList(),
      );
    }
  }
}
