import 'dart:io';
import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboard.dart';
import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
import 'package:pdf_creator/Screens/Gallery%20Crop/gallerycropcntl.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:pdf_creator/Utilities/utilities.dart';

class GalleryCropScreen extends StatefulWidget {
  const GalleryCropScreen({Key? key, this.images, this.cnt}) : super(key: key);
  final images;
  final cnt;

  @override
  State<GalleryCropScreen> createState() => _GalleryCropScreenState();
}

class _GalleryCropScreenState extends State<GalleryCropScreen> {
  final _CropCtrl = Get.put(galleryCropCntl());
  final _focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<File> croppedList = [];
  @override
  void initState() {
    _CropCtrl.ImgLst.addAll(widget.images);
    super.initState();
    _dashCtrl.nameController.value.clear();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _dashCtrl.nameController.value.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _dashCtrl.nameController.value.text.length,
        );
      }
    });
  }

  String formattedTime = DateFormat('hh:mm:ss a').format(DateTime.now());
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.themeDark.withOpacity(.3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          tooltip: "Exit",
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.themeDark.withOpacity(.7),
        title: Form(
          key: formKey,
          child: Obx(
            () => Container(
              margin: EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.white,
                cursorHeight: 20,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                  hintText: "Enter PDF Name",
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                focusNode: _focusNode,
                style: TextStyle(color: Colors.white, fontSize: 20),
                controller: _dashCtrl.nameController.value,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 170,
            child: Obx(
              () => ListView.builder(
                physics: BouncingScrollPhysics(),
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
                      child: Obx(
                        () => Container(
                          width: MediaQuery.of(context).size.width / 3.1,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                offset: ui.Offset(.6, .6),
                                blurStyle: BlurStyle.outer,
                                spreadRadius: .5,
                                blurRadius: .9,
                              ),
                            ],
                            border: _CropCtrl.selectedIndex.value == index
                                ? Border.all(color: Colors.white)
                                : null,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(_CropCtrl.ImgLst[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
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
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Obx(() {
            return Padding(
              key:
                  UniqueKey(), // Use UniqueKey for better widget identification
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      offset: ui.Offset(.6, .6),
                      blurStyle: BlurStyle.outer,
                      spreadRadius: .5,
                      blurRadius: .9,
                    ),
                  ],
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.circular(15),
                ),
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
              Icons.delete_outline_rounded,
              color: AppColor.whiteClr,
            ),
            onPressed: _deleteImage,
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
              Icons.rotate_90_degrees_cw_outlined,
              color: AppColor.whiteClr,
            ),
            onPressed: _rotateRight,
          ),
          TextButton(
            onPressed: () {
              _finished(context);
            },
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

  Future<void> _deleteImage() async {
    LoadingDialog.show(context);
    if (_dashCtrl.nameController.value.text.trim().isNotEmpty &&
        _cropCtrl.ImgLst.length != 1) {
      _CropCtrl.ImgLst.removeAt(_CropCtrl.selectedIndex.value);
      Get.back();
    }
    if (_cropCtrl.selectedIndex.value > 0) {
      _CropCtrl.selectedIndex.value = _CropCtrl.selectedIndex.value - 1;
    }

    if (croppedList.isNotEmpty) {
      if (_dashCtrl.nameController.value.text.trim().isNotEmpty &&
          _cropCtrl.ImgLst.length == 1) {
        Get.offAll(() => DashBoard());
        await _dashCtrl.saveDocument(
          imageList: croppedList,
          name: _dashCtrl.nameController.value.text.trim(),
          documentPath: croppedList[0].path,
          dateTime: '$formattedDate $formattedTime',
        );
      } else {
        LoadingDialog.hide(context);
        ErrorSnackbar().showSnackbar(context, "Please Enter Name");
      }
    } else {
      Get.back();
    }
  }

  final galleryCropCntl _cropCtrl = Get.put(galleryCropCntl());
  final DashCtrl _dashCtrl = Get.put(DashCtrl());

  Future<void> _finished(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      ui.Image bitmap = await _CropCtrl.controller.value.croppedBitmap();
      var data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
      var bytes = data!.buffer.asUint8List();
      Directory tempDir = await getTemporaryDirectory();
      File file =
          File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);

      if (_cropCtrl.selectedIndex.value < _cropCtrl.ImgLst.length) {
        if (_dashCtrl.nameController.value.text.trim().isNotEmpty ||
            _cropCtrl.ImgLst.length != 1) {
          croppedList.add(file);
          LoadingDialog.hide(context);
          _cropCtrl.ImgLst.removeAt(_cropCtrl.selectedIndex.value);
        } else {
          LoadingDialog.hide(context);
          ErrorSnackbar().showSnackbar(context, "Please Enter Name");
        }
      }

      if (_cropCtrl.ImgLst.isNotEmpty) {
        _cropCtrl.selectedIndex.value = 0;
      }

      if (_cropCtrl.ImgLst.isEmpty && _cropCtrl.selectedIndex.value == 0) {
        Get.offAll(() => DashBoard());
        await _dashCtrl.saveDocument(
          imageList: croppedList,
          name: _dashCtrl.nameController.value.text.trim(),
          documentPath: croppedList[0].path,
          dateTime: '$formattedDate $formattedTime',
        );
      }
    } catch (e) {
      print('Error while cropping image: $e');
    }
  }
}
