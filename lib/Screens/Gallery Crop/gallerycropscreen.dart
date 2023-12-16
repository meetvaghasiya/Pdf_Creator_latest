import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
import 'package:pdf_creator/Screens/Gallery%20Crop/gallerycropcntl.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class GalleryCropScreen extends StatefulWidget {
  const GalleryCropScreen({Key? key, this.images}) : super(key: key);
  final images;

  @override
  State<GalleryCropScreen> createState() => _GalleryCropScreenState();
}

class _GalleryCropScreenState extends State<GalleryCropScreen> {
  final _CropCtrl = Get.put(galleryCropCntl());

  @override
  void initState() {
    _CropCtrl.ImgLst.addAll(widget.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.themeDark,
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Obx(
              () => ListView.builder(
                itemCount: _CropCtrl.ImgLst.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _CropCtrl.selectedIndex.value = index;
                      print('Selected Index: ${_CropCtrl.selectedIndex.value}');
                      print('ImgLst Length: ${_CropCtrl.ImgLst.length}');
                    },
                    child: Padding(
                      key:
                          UniqueKey(), // Use UniqueKey for better widget identification
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.1,
                        decoration: BoxDecoration(
                          color: _CropCtrl.selectedIndex.value == index
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_CropCtrl.ImgLst[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Obx(() {
            return Padding(
              key:
                  UniqueKey(), // Use UniqueKey for better widget identification
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.grey,
                child: (_CropCtrl.selectedIndex < _CropCtrl.ImgLst.length)
                    ? CropImage(
                        paddingSize: 25.0,
                        alwaysMove: true,
                        controller: _CropCtrl.controller.value,
                        image: Image.file(File(_CropCtrl
                            .ImgLst[_CropCtrl.selectedIndex.value].path)),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            );
          }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColor.whiteClr,
            ),
            onPressed: () {
              _CropCtrl.controller.value.rotation = CropRotation.up;
              _CropCtrl.controller.value.crop =
                  const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              _CropCtrl.controller.value.aspectRatio = 1.0;
            },
          ),
          IconButton(
            icon: Icon(
              Icons.aspect_ratio,
              color: AppColor.whiteClr,
            ),
            onPressed: _aspectRatios,
          ),
          IconButton(
            icon: Icon(
              Icons.rotate_90_degrees_ccw_outlined,
              color: AppColor.whiteClr,
            ),
            onPressed: _rotateLeft,
          ),
          IconButton(
            icon: Icon(
              Icons.rotate_90_degrees_cw_outlined,
              color: AppColor.whiteClr,
            ),
            onPressed: _rotateRight,
          ),
          TextButton(
            onPressed: _finished,
            child: Text(
              'Done',
              style: TextStyle(
                color: AppColor.whiteClr,
              ),
            ),
          ),
        ],
      );

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            // special case: no aspect ratio
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );
    if (value != null) {
      _CropCtrl.controller.value.aspectRatio = value == -1 ? null : value;
      _CropCtrl.controller.value.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _rotateLeft() async => _CropCtrl.controller.value.rotateLeft();

  Future<void> _rotateRight() async => _CropCtrl.controller.value.rotateRight();

  Future<void> _finished() async {
    DashCtrl _dashCtrl = Get.put(DashCtrl());
    // try {
    final image = await _CropCtrl.controller.value.croppedImage();
    _CropCtrl.croppedList.add(image);

    if (_CropCtrl.selectedIndex.value < _CropCtrl.ImgLst.length) {
      _CropCtrl.ImgLst.removeAt(_CropCtrl.selectedIndex.value);
    }

    if (_CropCtrl.ImgLst.isNotEmpty) {
      _CropCtrl.selectedIndex.value = 0;
    }

    if (_CropCtrl.ImgLst.length == 0 && _CropCtrl.selectedIndex.value == 0) {
      var data = _CropCtrl.croppedList.map((image) {
        if (image is Image) {
          ImageProvider<Object> uiImageProvider = image.image;
          if (uiImageProvider is FileImage) {
            return File(uiImageProvider.file.path);
          } else {
            throw ArgumentError('Invalid UiImageProvider type');
          }
        } else {
          throw ArgumentError('Invalid type in _CropCtrl.croppedList');
        }
      }).toList();

      Get.back();
      final GlobalKey<AnimatedListState> animatedListKey =
          GlobalKey<AnimatedListState>();
      final formKey = GlobalKey<FormState>();
      final TextEditingController nameController = TextEditingController();
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Generate PDF'),
            content: Form(
              key: formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter PDF Name";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter Name"),
                style: const TextStyle(color: Colors.black, fontSize: 20),
                controller: nameController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                  String formattedTime =
                      DateFormat('hh:mm:ss a').format(DateTime.now());
                  if (formKey.currentState!.validate()) {
                    _dashCtrl.saveDocument(
                      imageList: data,
                      name: nameController.text.trim(),
                      documentPath: data[0].path,
                      dateTime: '$formattedDate $formattedTime',
                      animatedListKey: animatedListKey,
                      shareLink: '',
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Create PDF'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Add Page'),
              ),
            ],
          );
        },
      );
    }
    // } catch (e) {
    //   print('Error while cropping image: $e');
    // }
  }
}
