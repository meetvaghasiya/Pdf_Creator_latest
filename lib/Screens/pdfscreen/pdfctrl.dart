import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PdfCtrl extends GetxController {
  final GetStorage box = GetStorage();

  RxList<int> bookmarks = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load bookmarks from storage when the controller is initialized
    loadBookmarks();
  }

  void loadBookmarks() {
    dynamic storedBookmarks = box.read('bookmarks');
    if (storedBookmarks != null) {
      bookmarks = (storedBookmarks as List<dynamic>)
          .map((item) => item as int)
          .toList()
          .obs;
    }
  }

  void saveBookmarks() {
    // Save bookmarks to storage
    box.write('bookmarks', bookmarks.toList());
  }

  void toggleBookmark(int page) {
    if (bookmarks.contains(page)) {
      bookmarks.remove(page);
    } else {
      bookmarks.add(page);
    }
    // Save bookmarks after toggling
    saveBookmarks();
  }

  bool isBookmarked(int index) {
    return bookmarks.contains(index);
  }
}
