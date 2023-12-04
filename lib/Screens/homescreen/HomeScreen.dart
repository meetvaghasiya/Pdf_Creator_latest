import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/Screens/Search%20Screen/searchscreen.dart';
import 'package:pdf_creator/provider/documentprovider.dart';
import 'package:pdf_creator/screens/newimage/newimage.dart';
import 'package:pdf_creator/screens/showimage/showimage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../pdfscreen/pdfscreen.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
  final _key = GlobalKey<ExpandableFabState>();
  File? selectImage;
  File? imageFile;

  String? _imagePath;

  Future<void> getImageFromCamera() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = true;

    try {
      //Make sure to await the call to detectEdge.
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (success) {
        _imagePath = imagePath;
      }
    });

    // Timer(const Duration(seconds: 1), () {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(
    //       builder: (context) => ShowImage(
    //
    //         width: width,
    //         height: height,
    //         file: widget.file,
    //         imagePixelSize: imagePixelSize,
    //         animatedListKey:
    //         widget.animatedListKey,
    //       )));
    // });
  }

  Future<void> getImageFromGallery() async {
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = false;
    try {
      success = await EdgeDetection.detectEdgeFromGallery(
        imagePath,
        androidCropTitle: 'abc',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (success) {
        // Dialog
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _imagePath != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _imagePath != null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(_imagePath ?? ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Please selected an image.")),
            ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        // duration: const Duration(milliseconds: 500),
        // distance: 200.0,
        // type: ExpandableFabType.up,
        // pos: ExpandableFabPos.left,
        // childrenOffset: const Offset(0, 20),
        // fanAngle: 40,
        // openButtonBuilder: RotateFloatingActionButtonBuilder(
        //   child: const Icon(Icons.abc),
        //   fabSize: ExpandableFabSize.large,
        //   foregroundColor: Colors.amber,
        //   backgroundColor: Colors.green,
        //   shape: const CircleBorder(),
        //   angle: 3.14 * 2,
        // ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 60,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.close,
                size: 40,
              ),
            );
          },
        ),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 5,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        distance: 70,
        children: [
          FloatingActionButton.extended(
            label: SizedBox(),
            shape: const CircleBorder(),
            // heroTag: null,
            extendedIconLabelSpacing: 0,
            icon: const Icon(
              Icons.camera_alt_outlined,
              size: 30,
            ),

            onPressed: () {
              getImageFromCamera();
              final state = _key.currentState;
              if (state != null) {
                state.toggle();
              }
            },
          ),
          FloatingActionButton.extended(
            label: SizedBox(),
            extendedIconLabelSpacing: 0,
            shape: const CircleBorder(),
            heroTag: null,
            icon: const Icon(
              Icons.photo_camera_back_outlined,
              size: 30,
            ),
            onPressed: () {
              getImageFromGallery();
              final state = _key.currentState;
              if (state != null) {
                state.toggle();
              }
            },
          ),
        ],
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {});
    selectImage = File(returnedImage!.path);
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {});
    selectImage = File(returnedImage!.path);
  }

  Future _cropImage() async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: imageFile!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          imageFile = File(cropped.path);
        });
      }
    }
  }

  void _clearImage() {
    setState(() {
      imageFile = null;
    });
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MethodChannel channel = MethodChannel('opencv');

  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  String? _imagePath;
  Future<void> getImageFromCamera(context) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = false;

    try {
      //Make sure to await the call to detectEdge.
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (success) {
        _imagePath = imagePath;
      }
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewImage(_imagePath as File?, animatedListKey)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doc Scan"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              showSearch(context: context, delegate: Search());
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  _pickImageFromCamera(context);
                },
              ),
              Container(
                color: Colors.white.withOpacity(0.2),
                width: 2,
                height: 15,
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  getImageFromCamera(context);
                },
              )
            ],
          )),
      body: FutureBuilder(
        future: getAllDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("has not data");
            return SizedBox();
          }
          if (snapshot.hasError) {
            print("error");
            return CircularProgressIndicator();
          }
          return Container(
              height: MediaQuery.of(context).size.height - 81,
              child: AnimatedList(
                key: animatedListKey,
                itemBuilder: (context, index, animation) {
                  if (index ==
                      Provider.of<DocumentProvider>(context)
                              .allDocuments
                              .length -
                          1) {
                    print("last");
                    return SizedBox(height: 100);
                  }
                  return buildDocumentCard(index, animation, context);
                },
                initialItemCount:
                    Provider.of<DocumentProvider>(context).allDocuments.length,
              ));
        },
      ),
    );
  }

  File? selectImage;
  Future _pickImageFromGallery(context) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {});
    selectImage = File(returnedImage!.path);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewImage(selectImage, animatedListKey)));
  }

  Future _pickImageFromCamera(context) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {});
    selectImage = File(returnedImage!.path);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewImage(selectImage, animatedListKey)));
  }
  // void chooseImage(ImageSource source) async {
  //   File fileGallery = await ImagePicker.pickImage(source: source);
  //   if (fileGallery != null) {
  //     _file = fileGallery;
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => NewImage(fileGallery, animatedListKey)));
  //   }
  // }

  Future<bool> getAllDocuments() async {
    print("inside get documents");
    return await Provider.of<DocumentProvider>(context as BuildContext,
            listen: true)
        .getDocuments();
  }

  Future<void> onRefresh() async {
    Provider.of<DocumentProvider>(context as BuildContext, listen: false)
        .getDocuments();
  }

  Widget buildDocumentCard(int index, Animation<double> animation, context) {
    return SizeTransition(
      sizeFactor: animation,
      child: StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PDFScreen(
                document:
                    Provider.of<DocumentProvider>(context).allDocuments[index],
                animatedListKey: animatedListKey,
              ),
            ));
          },
          child: Card(
            color: ThemeData.dark().cardColor,
            elevation: 3,
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.grey[300]!),
                          right: BorderSide(color: Colors.grey[300]!),
                          top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Image.file(
                      new File(Provider.of<DocumentProvider>(context)
                          .allDocuments[index]
                          .documentPath),
                      height: 150,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 150,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            Provider.of<DocumentProvider>(context)
                                .allDocuments[index]
                                .name,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              Provider.of<DocumentProvider>(context)
                                      .allDocuments[index]
                                      .dateTime
                                      .day
                                      .toString() +
                                  "-" +
                                  Provider.of<DocumentProvider>(context)
                                      .allDocuments[index]
                                      .dateTime
                                      .month
                                      .toString() +
                                  "-" +
                                  Provider.of<DocumentProvider>(context)
                                      .allDocuments[index]
                                      .dateTime
                                      .year
                                      .toString(),
                              style: TextStyle(color: Colors.grey[400]),
                            )),
                      ],
                    )),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  // color: ThemeData.dark().accentColor,
                                ),
                                onPressed: () {
                                  shareDocument(Provider.of<DocumentProvider>(
                                          context,
                                          listen: false)
                                      .allDocuments[index]
                                      .pdfPath);
                                }),
                            IconButton(
                              icon: Icon(
                                Icons.cloud_upload,
                                // color: ThemeData.dark().accentColor,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  // color: ThemeData.dark().accentColor,
                                ),
                                onPressed: () {
                                  showModalSheet(
                                      index: index,
                                      filePath: Provider.of<DocumentProvider>(
                                              context,
                                              listen: false)
                                          .allDocuments[index]
                                          .documentPath,
                                      dateTime: Provider.of<DocumentProvider>(
                                              context,
                                              listen: false)
                                          .allDocuments[index]
                                          .dateTime,
                                      context: context,
                                      name: Provider.of<DocumentProvider>(
                                              context,
                                              listen: false)
                                          .allDocuments[index]
                                          .name,
                                      pdfPath: Provider.of<DocumentProvider>(
                                              context,
                                              listen: false)
                                          .allDocuments[index]
                                          .pdfPath);
                                })
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void shareDocument(String pdfPath) async {
    await FlutterShare.shareFile(title: "pdf", filePath: pdfPath);
  }

  void showModalSheet(
      {int? index,
      String? filePath,
      String? name,
      DateTime? dateTime,
      BuildContext? context,
      String? pdfPath}) {
    showModalBottomSheet(
      context: context!,
      builder: (context) {
        return Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Image.file(
                        new File(filePath!),
                        height: 80,
                        width: 50,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(left: 12, bottom: 12),
                        child: Text(
                          name!,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            dateTime!.day.toString() +
                                "-" +
                                dateTime!.month.toString() +
                                "-" +
                                dateTime.year.toString(),
                            style: TextStyle(color: Colors.grey[400]),
                          )),
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rename"),
                onTap: () {
                  Navigator.pop(context);
                  showRenameDialog(
                      index: index!, name: name, dateTime: dateTime);
                },
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text("Print"),
                onTap: () async {
                  Navigator.pop(context);
                  final pdf = File(pdfPath!);
                  await Printing.layoutPdf(
                      onLayout: (_) => pdf.readAsBytesSync());
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteDialog1(index: index!, dateTime: dateTime);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void showDeleteDialog1({int? index, DateTime? dateTime, context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Delete file",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 2,
            ),
            Text(
              "Are you sure you want to delete this file?",
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        )),
        actions: <Widget>[
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();

              Provider.of<DocumentProvider>(context, listen: false)
                  .deleteDocument(
                      index!, dateTime!.millisecondsSinceEpoch.toString());
              Timer(Duration(milliseconds: 300), () {
                animatedListKey.currentState!.removeItem(
                    index,
                    (context, animation) =>
                        buildDocumentCard(index, animation, context));
              });
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  void showRenameDialog(
      {int? index, DateTime? dateTime, String? name, context}) {
    TextEditingController controller = TextEditingController();
    controller.text = name!;
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
            child: Column(
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
        )),
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
                Provider.of<DocumentProvider>(context, listen: false)
                    .renameDocument(
                        index!,
                        dateTime!.millisecondsSinceEpoch.toString(),
                        controller.text);
              },
              child: Text("Rename")),
        ],
      ),
    );
  }
}
