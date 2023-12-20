import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class galleryCropCntl extends GetxController {
  RxInt selectedIndex = 0.obs;
  Rx<CropController> controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  ).obs;
  RxList ImgLst = [].obs;
}
