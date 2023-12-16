import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:pdf_creator/Screens/Gallery%20Crop/gallerycropcntl.dart';
import 'package:pdf_creator/Screens/Search%20Screen/searchscreen.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';
import 'package:pdf_creator/Utilities/classes.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:pdf_creator/Screens/Gallery%20Crop/gallerycropscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dashboardCtrl.dart';
import 'package:printing/printing.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // ignore: unused_field
  final DashCtrl _dashCtrl = Get.put(DashCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.themeDark,
        title: Text(
          "Dashboard",
          style: TextStyle(
              color: AppColor.whiteClr,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  'V ${snapshot.data!.version}',
                  style: TextStyle(color: AppColor.whiteClr),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: AppColor.themeDark,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverToBoxAdapter(
              child: FunctionCard(),
            ),
          ];
        },
        body: const PDFList(),
      ),
    );
  }
}

class PDFList extends StatefulWidget {
  const PDFList({super.key});
  @override
  State<PDFList> createState() => _PDFListState();
}

class _PDFListState extends State<PDFList> {
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
  final DashCtrl _dashCtrl = Get.find<DashCtrl>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  "PDF History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    showSearch(context: context, delegate: Search());
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _dashCtrl.getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    }
                    if (snapshot.hasError) {
                      return CircularProgressIndicator();
                    }
                    return SizedBox(
                        height: MediaQuery.of(context).size.height - 81,
                        child: Obx(
                          () => _dashCtrl.allDocuments.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: buildDocumentCard(index, context),
                                    );
                                  },
                                  itemCount: _dashCtrl.allDocuments.length,
                                )
                              : Center(
                                  child: Text("No Data Found !"),
                                ),
                        ));
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildDocumentCard(
    int index,
    context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFScreen(
            index: index,
            document: _dashCtrl.allDocuments[index],
            animatedListKey: animatedListKey,
          ),
        ));
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              stops: [.25, .42],
              colors: [AppColor.themeDark.withOpacity(.6), AppColor.themeDark],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border(
                      left: BorderSide(color: Colors.grey[300]!),
                      right: BorderSide(color: Colors.grey[300]!),
                      top: BorderSide(color: Colors.grey[300]!),
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_dashCtrl.allDocuments[index].documentPath),
                      height: 150,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _dashCtrl.allDocuments[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          // "${formattedDate} ${formattedTime}",
                          _dashCtrl.allDocuments[index].dateTime,
                          style: TextStyle(color: AppColor.whiteClr),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 180,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.share,
                                color: AppColor.whiteClr,
                              ),
                              onPressed: () {
                                _dashCtrl.sharePDF(context, index);
                              }),
                          IconButton(
                            icon: Icon(
                              Icons.cloud_upload,
                              color: AppColor.whiteClr,
                            ),
                            onPressed: () async {
                              final pdf =
                                  File(_dashCtrl.allDocuments[index].pdfPath);
                              await Printing.layoutPdf(
                                  onLayout: (context) => pdf.readAsBytesSync());
                            },
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: AppColor.whiteClr,
                              ),
                              onPressed: () {
                                showModalSheet(
                                    index: index,
                                    filePath: _dashCtrl
                                        .allDocuments[index].documentPath,
                                    dateTime: _dashCtrl
                                        .allDocuments[index].dateTime
                                        .toString(),
                                    context: context,
                                    name: _dashCtrl.allDocuments[index].name,
                                    pdfPath:
                                        _dashCtrl.allDocuments[index].pdfPath);
                              })
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRenameDialog({int? index, String? dateTime, String? name, context}) {
    TextEditingController controller = TextEditingController();
    controller.text = name!;
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Rename"),
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                  suffix: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                      })),
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel")),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _dashCtrl.allDocuments[index!].name = controller.text;
                });
                _dashCtrl.renameDocument(
                    index!, dateTime.toString(), controller.text);
              },
              child: Text("Rename")),
        ],
      ),
    );
  }

  void showModalSheet(
      {int? index,
      String? filePath,
      String? name,
      String? dateTime,
      BuildContext? context,
      String? pdfPath}) {
    showModalBottomSheet(
      context: context!,
      builder: (context) {
        return Container(
          color: AppColor.themeDark,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width * .17,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(filePath!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(left: 12, bottom: 12),
                        child: Text(
                          name!,
                          style: TextStyle(
                              color: AppColor.whiteClr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            _dashCtrl.allDocuments[index!].dateTime,
                            style: TextStyle(
                              color: AppColor.whiteClr,
                            ),
                          )),
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: AppColor.greyClr,
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColor.whiteClr,
                ),
                title: Text(
                  "Rename",
                  style: TextStyle(
                    color: AppColor.whiteClr,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showRenameDialog(
                      index: index,
                      name: name,
                      dateTime: dateTime,
                      context: context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: AppColor.whiteClr,
                ),
                title: Text(
                  "Delete",
                  style: TextStyle(
                    color: AppColor.whiteClr,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteDialog1(
                    index: index,
                    dateTime: dateTime,
                    context: context,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void showDeleteDialog1({int? index, String? dateTime, context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Delete file",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 2,
            ),
            Text(
              "Are you sure you want to delete this file?",
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();

              _dashCtrl.deleteDocument(index!, dateTime.toString().toString());
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionCard extends StatefulWidget {
  const FunctionCard({super.key});

  @override
  State<FunctionCard> createState() => _FunctionCardState();
}

class _FunctionCardState extends State<FunctionCard> {
  TextEditingController nameController = TextEditingController();
  final _focusNode = FocusNode();
  // ignore: unused_field
  final DashCtrl _dashCtrl = Get.find<DashCtrl>();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        nameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: nameController.text.length,
        );
      }
    });
    super.initState();
  }

  // Future<void> takeImage(BuildContext context) async {
  //   bool isCameraGranted = await Permission.camera.request().isGranted;
  //   List<File> capturedImages = [];

  //   if (!isCameraGranted) {
  //     isCameraGranted =
  //         await Permission.camera.request() == PermissionStatus.granted;
  //   }

  //   if (!isCameraGranted) {
  //     return;
  //   }

  //   final GlobalKey<AnimatedListState> animatedListKey =
  //       GlobalKey<AnimatedListState>();
  //   bool continueCapturing = true;

  //   while (continueCapturing) {
  //     String imagePath = join((await getApplicationSupportDirectory()).path,
  //         "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

  //     bool success = await EdgeDetection.detectEdge(
  //       imagePath,
  //       canUseGallery: true,
  //       androidScanTitle: 'Scanning',
  //       androidCropTitle: 'Crop',
  //       androidCropBlackWhiteTitle: 'Black White',
  //       androidCropReset: 'Reset',
  //     );

  //     if (success) {
  //       capturedImages.add(File(imagePath));
  //       final formKey = GlobalKey<FormState>();
  //       final TextEditingController nameController = TextEditingController();
  //       await showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Generate PDF'),
  //             content: Form(
  //               key: formKey,
  //               child: TextFormField(
  //                 validator: (value) {
  //                   if (value == null || value.trim().isEmpty) {
  //                     return "Please Enter PDF Name";
  //                   }
  //                   return null;
  //                 },
  //                 decoration: InputDecoration(hintText: "Enter Name"),
  //                 style: const TextStyle(color: Colors.black, fontSize: 20),
  //                 controller: nameController,
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   String formattedDate =
  //                       DateFormat('dd-MM-yyyy').format(DateTime.now());
  //                   String formattedTime =
  //                       DateFormat('hh:mm:ss a').format(DateTime.now());
  //                   if (formKey.currentState!.validate()) {
  //                     _dashCtrl.saveDocument(
  //                       imageList: capturedImages,
  //                       name: nameController.text.trim(),
  //                       documentPath: capturedImages[0].path,
  //                       dateTime: '$formattedDate $formattedTime',
  //                       animatedListKey: animatedListKey,
  //                       shareLink: '',
  //                     );
  //                     continueCapturing = false;
  //                     Navigator.of(context).pop(false);
  //                   }
  //                 },
  //                 child: const Text('Create PDF'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //                 child: const Text('Add Page'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       break;
  //     }
  //   }
  // }

  // List<File> _selectedImages = [];

  // _imgFromGallery() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();
  //   if (statuses[Permission.storage]!.isGranted) {
  //     final picker = ImagePicker();
  //     List<XFile>? result = await picker.pickMultiImage(
  //       imageQuality: 50,
  //     );
  //     if (result != null) {
  //       for (var image in result) {
  //         _cropImage(File(image.path));
  //       }
  //     }
  //   } else {
  //     print('No permission provided');
  //   }
  // }

  // _cropImage(File imgFile) async {
  //   print("4rgtgfd+==>${imgFile.path}");
  //   final croppedFile = await ImageCropper().cropImage(
  //     sourcePath: imgFile.path,
  //     aspectRatioPresets: Platform.isAndroid
  //         ? [
  //             CropAspectRatioPreset.square,
  //             CropAspectRatioPreset.ratio3x2,
  //             CropAspectRatioPreset.original,
  //             CropAspectRatioPreset.ratio4x3,
  //             CropAspectRatioPreset.ratio16x9,
  //           ]
  //         : [
  //             CropAspectRatioPreset.original,
  //             CropAspectRatioPreset.square,
  //             CropAspectRatioPreset.ratio3x2,
  //             CropAspectRatioPreset.ratio4x3,
  //             CropAspectRatioPreset.ratio5x3,
  //             CropAspectRatioPreset.ratio5x4,
  //             CropAspectRatioPreset.ratio7x5,
  //             CropAspectRatioPreset.ratio16x9,
  //           ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: "Image Cropper",
  //         toolbarColor: AppColor.themeDark,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false,
  //       ),
  //       IOSUiSettings(
  //         title: "Image Cropper",
  //       )
  //     ],
  //   );

  //   if (croppedFile != null) {
  //     setState(() async {
  //       print("abc==>${_selectedImages}");
  //       _selectedImages.add(File(croppedFile.path));
  //       final GlobalKey<AnimatedListState> animatedListKey =
  //           GlobalKey<AnimatedListState>();
  //       final formKey = GlobalKey<FormState>();
  //       final TextEditingController nameController = TextEditingController();
  //       await showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Generate PDF'),
  //             content: Form(
  //               key: formKey,
  //               child: TextFormField(
  //                 validator: (value) {
  //                   if (value == null || value.trim().isEmpty) {
  //                     return "Please Enter PDF Name";
  //                   }
  //                   return null;
  //                 },
  //                 decoration: InputDecoration(hintText: "Enter Name"),
  //                 style: const TextStyle(color: Colors.black, fontSize: 20),
  //                 controller: nameController,
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   print("path==>${croppedFile.path}");
  //                   String formattedDate =
  //                       DateFormat('dd-MM-yyyy').format(DateTime.now());
  //                   String formattedTime =
  //                       DateFormat('hh:mm:ss a').format(DateTime.now());
  //                   if (formKey.currentState!.validate()) {
  //                     _dashCtrl.saveDocument(
  //                       imageList: _selectedImages,
  //                       name: nameController.text.trim(),
  //                       documentPath: _selectedImages[0].path,
  //                       dateTime: '$formattedDate $formattedTime',
  //                       animatedListKey: animatedListKey,
  //                       shareLink: '',
  //                     );
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: const Text('Create PDF'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //                 child: const Text('Add Page'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     });
  //   }
  // }

  List<XFile>? receivedFiles = [];
  List<File> croppedFiles = [];

  _imgFromGallery() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      final picker = ImagePicker();
      List<XFile>? result = await picker.pickMultiImage(
        imageQuality: 50,
      );

      if (result != null) {
        Get.to(() => GalleryCropScreen(images: result,));
      } else {
        print('No images selected');
      }
    } else {
      print('No storage permission provided');
    }
  }



  // Future<void> _gallery() async {
  //   try {
  //     List<String>? imagePaths = await getGallery.getPictures(true);

  //     if (imagePaths != null && imagePaths.isNotEmpty) {
  //       await _showDialog(imagePaths);
  //     } else {
  //       // Handle the case where no images were selected or captured
  //     }
  //   } catch (e) {
  //     // Handle the case where permission is not granted
  //     print('Permission not granted: $e');
  //   }
  // }


  Future<void> _captureAndShowDialog() async {
    try {
      List<String>? imagePaths = await getCamera.getPictures(true);

      if (imagePaths != null && imagePaths.isNotEmpty) {
        await _showDialog(imagePaths);
      } else {
        // Handle the case where no images were selected or captured
      }
    } catch (e) {
      // Handle the case where permission is not granted
      print('Permission not granted: $e');
    }
  }

  Future<void> _showDialog(List<String> imagePaths) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final GlobalKey<AnimatedListState> animatedListKey =
        GlobalKey<AnimatedListState>();

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
              onPressed: () async {
                print("path==>${imagePaths}");
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(DateTime.now());
                String formattedTime =
                    DateFormat('hh:mm:ss a').format(DateTime.now());

                if (formKey.currentState!.validate()) {
                  // Convert image paths to File objects
                  List<File> imageFiles =
                      imagePaths.map((path) => File(path)).toList();

                  // Assuming you have a function to create the PDF using imageFiles
                  _dashCtrl.saveDocument(
                    imageList: imageFiles,
                    name: nameController.text.trim(),
                    documentPath: imageFiles[0]
                        .path, // You might want to adjust this based on your logic
                    dateTime: '$formattedDate $formattedTime',
                    animatedListKey: animatedListKey,
                    shareLink: '',
                  );

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Create PDF'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog
              },
              child: const Text('Add Page'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          height: h * 0.15,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.functionCard,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Convert Image To PDf",
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColor.themeDark,
                        child: Icon(
                          Icons.photo_camera_back_outlined,
                          color: AppColor.whiteClr,
                        ),
                      ),
                      DottedDivider(),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColor.themeDark,
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: AppColor.whiteClr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        final h = MediaQuery.of(context).size.height;

                        return Container(
                          height: h * 0.25, // Adjust the height as needed
                          decoration: BoxDecoration(
                            color: AppColor.themeDark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Text(
                                  'Create PDF From',
                                  style: TextStyle(
                                    color: AppColor.whiteClr,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: AppColor.whiteClr,
                                  ),
                                ),
                              ),
                              Card(
                                color: AppColor.themeDark.withOpacity(.5),
                                child: ListTile(
                                  title: Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: AppColor.whiteClr,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColor.whiteClr,
                                  ),
                                  onTap: () {
                                    _captureAndShowDialog();
                                    Get.back();
                                  },
                                ),
                              ),
                              Card(
                                color: AppColor.themeDark.withOpacity(.5),
                                child: ListTile(
                                  title: Text(
                                    'Choose Photo',
                                    style: TextStyle(
                                      color: AppColor.whiteClr,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.photo_camera_back_outlined,
                                    color: AppColor.whiteClr,
                                  ),
                                  onTap: () async {
                                    _imgFromGallery();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Use Now",
                    style: TextStyle(color: AppColor.blackClr),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h * 0.003,
      width: w * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (int i = 0; i < 10; i++)
            Container(
              width: 8.0,
              height: 2.0,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
            ),
        ],
      ),
    );
  }
}
