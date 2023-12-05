import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/Screens/Search%20Screen/searchscreen.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';
import 'package:pdf_creator/Utilities/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../provider/documentprovider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.themeDark,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
              color: AppColor.whiteClr,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: AppColor.themeDark,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: FunctionCard(),
            ),
          ];
        },
        body: PDFList(),
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
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
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
          // height: MediaQuery.of(context).size.height * .1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "PDF History",
                  style: TextStyle(
                      // color: AppColor.whiteClr,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    showSearch(context: context, delegate: Search());
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<DocumentProvider>(context, listen: false)
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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
                              return SizedBox(height: 100);
                            }
                            return buildDocumentCard(index, animation, context);
                          },
                          initialItemCount:
                              Provider.of<DocumentProvider>(context)
                                  .allDocuments
                                  .length,
                        ));
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildDocumentCard(int index, Animation<double> animation, context) {
    return SizeTransition(
      sizeFactor: animation,
      child: StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PDFScreen(
                index: index,
                document:
                    Provider.of<DocumentProvider>(context).allDocuments[index],
                animatedListKey: animatedListKey,
              ),
            ));
          },
          child: Card(
            color: AppColor.listtileClr,
            elevation: 3,
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
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
                        File(Provider.of<DocumentProvider>(context)
                            .allDocuments[index]
                            .documentPath),
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
                                  color: AppColor.whiteClr,
                                ),
                                onPressed: () {
                                  sharePdf(Provider.of<DocumentProvider>(
                                          context,
                                          listen: false)
                                      .allDocuments[index]
                                      .pdfPath);
                                  // shareDocument(Provider.of<DocumentProvider>(
                                  //         context,
                                  //         listen: false)
                                  //     .allDocuments[index]
                                  //     .pdfPath);
                                }),
                            IconButton(
                              icon: Icon(
                                Icons.cloud_upload,
                                color: AppColor.whiteClr,
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                final pdf = File(Provider.of<DocumentProvider>(
                                        context,
                                        listen: false)
                                    .allDocuments[index]
                                    .pdfPath);
                                await Printing.layoutPdf(
                                    onLayout: (context) =>
                                        pdf.readAsBytesSync());
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

  Future<void> sharePdf(String PDFpath) async {
    try {
      // Replace 'your_pdf_file.pdf' with the actual name of your PDF file.
      String pdfFileName = PDFpath;

      // Get the directory where the PDF file is stored.
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String pdfFilePath = PDFpath;
      // String pdfFilePath = '${appDocDir.path}/$pdfFileName';

      // Check if the PDF file exists.
      if (await File(pdfFilePath).exists()) {
        // Specify a subject for the share dialog (optional).
        String subject = 'This File Shared From PDF Creator';

        // Share the PDF file.
        Share.shareFiles([pdfFilePath], subject: subject);
      } else {
        print('PDF file not found.');
      }
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  // void shareDocument(String pdfPath) async {
  //   await FlutterShare.shareFile(title: "pdf", filePath: pdfPath);
  // }

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
                        padding: EdgeInsets.only(left: 12, bottom: 12),
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
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            dateTime!.day.toString() +
                                "-" +
                                dateTime!.month.toString() +
                                "-" +
                                dateTime.year.toString(),
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
                      index: index!,
                      name: name,
                      dateTime: dateTime,
                      context: context);
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.print),
              //   title: Text("Print"),
              //   onTap: () async {
              //     Navigator.pop(context);
              //     final pdf = File(pdfPath!);
              //     await Printing.layoutPdf(
              //         onLayout: (_) => pdf.readAsBytesSync());
              //   },
              // ),
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
                    index: index!,
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
                animatedListKey.currentState?.removeItem(
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

class FunctionCard extends StatefulWidget {
  const FunctionCard({super.key});

  @override
  State<FunctionCard> createState() => _FunctionCardState();
}

class _FunctionCardState extends State<FunctionCard> {
  String? _imagePath;
  final _key = GlobalKey<ExpandableFabState>();
  TextEditingController nameController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    nameController.text = "Scan " + DateTime.now().toString();
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

  Future<void> getImageFromCamera(context) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    File? _file;
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
    final GlobalKey<AnimatedListState> animatedListKey =
        GlobalKey<AnimatedListState>();
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
        _file = File(imagePath);
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create PDF'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    focusNode: _focusNode,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    controller: nameController,
                  ), // Add buttons to the dialog
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Close the dialog

                    Provider.of<DocumentProvider>(context, listen: false)
                        .saveDocument(
                            name: nameController.text.trim(),
                            documentPath: _file!.path,
                            dateTime: DateTime.now(),
                            animatedListKey: animatedListKey,
                            shareLink: '');
                    Navigator.of(context).pop();
                  },
                  child: Text('Save PDF'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<void> getImageFromGallery(context) async {
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    String filePath = imagePath;
    File? _file;

    String imageName = basenameWithoutExtension(filePath);

    print('Filename without extension: $imageName');
    print("======>${imagePath}");
    final GlobalKey<AnimatedListState> animatedListKey =
        GlobalKey<AnimatedListState>();
    bool success = false;
    try {
      success = await EdgeDetection.detectEdgeFromGallery(
        imagePath,
        androidCropTitle: 'Adjust View',
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
        _file = File(imagePath);
        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create PDF'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    focusNode: _focusNode,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    controller: nameController,
                  ), // Add buttons to the dialog
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Close the dialog

                    Provider.of<DocumentProvider>(context, listen: false)
                        .saveDocument(
                            name: nameController.text.trim(),
                            documentPath: _file!.path,
                            dateTime: DateTime.now(),
                            animatedListKey: animatedListKey,
                            shareLink: '');
                    Navigator.of(context).pop();
                  },
                  child: Text('Save PDF'),
                ),
              ],
            );
          },
        );
      }
    });
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
                  Text(
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
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: h * .21,
                          decoration: BoxDecoration(
                            color: AppColor.themeDark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
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
                                color: AppColor.listtileClr,
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
                                    getImageFromCamera(context);
                                  },
                                ),
                              ),
                              Card(
                                color: AppColor.listtileClr,
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
                                  onTap: () {
                                    getImageFromGallery(context);
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
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.003, // Adjust the height of the line as needed
      width: w * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (int i = 0; i < 10; i++)
            Container(
              width: 8.0,
              height: 2.0,
              color: Colors.black,
              margin: EdgeInsets.symmetric(horizontal: 2.0),
            ),
        ],
      ),
    );
  }
}
