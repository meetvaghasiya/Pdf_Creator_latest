import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class galleryCropCntl extends GetxController {
//   RxInt selectedIndex = 0.obs;
//   Rx<CropController> controller = CropController(
//     aspectRatio: 1,
//     defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
//   ).obs;
//   RxList ImgLst = [].obs;
//   RxDouble progressValue = 0.0.obs; // Add a progress value
//   final loadingState = ValueNotifier<bool>(false);
// }

class galleryCropCntl extends GetxController {
  RxInt selectedIndex = 0.obs;
  Rx<CropController> controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  ).obs;
  RxList ImgLst = [].obs;
}
