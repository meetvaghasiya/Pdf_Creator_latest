// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
//
// class PdfCtrl extends GetxController {
//   final GetStorage box = GetStorage();
//   final DashCtrl _dashCtrl = Get.put(DashCtrl());
//
//   RxList<int> bookmarks = <int>[].obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Load bookmarks from storage when the controller is initialized
//     loadBookmarks();
//   }
//
//   void loadBookmarks() {
//     dynamic storedBookmarks = box.read('bookmarks');
//     if (storedBookmarks != null) {
//       bookmarks = (storedBookmarks as List<dynamic>)
//           .map((item) => item as int)
//           .toList()
//           .obs;
//     }
//   }
//
//   void saveBookmarks() {
//     // Save bookmarks to storage
//     box.write('bookmarks', bookmarks.toList());
//   }
//
//   void toggleBookmark(int page) {
//     if (bookmarks.contains(page)) {
//       bookmarks.remove(page);
//     } else {
//       bookmarks.add(page);
//     }
//     // Save bookmarks after toggling
//     saveBookmarks();
//   }
//
//   bool isBookmarked(int index) {
//     return bookmarks.contains(index);
//   }
//
//   void toggleBookmarkAndShowSnackbar(int index) {
//     final bool isCurrentlyBookmarked = isBookmarked(index);
//     final message = isCurrentlyBookmarked
//         ? 'Removed bookmark for ${_dashCtrl.allDocuments[index].name}'
//         : 'Saved bookmark for ${_dashCtrl.allDocuments[index].name}';
//
//     // Toggle the bookmark
//     toggleBookmark(index);
//
//     // Show a snackbar
//     Get.snackbar(
//       'Bookmark Status',
//       message,
//       duration: Duration(seconds: 2),
//     );
//   }
//
// }
