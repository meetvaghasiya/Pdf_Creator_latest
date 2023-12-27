// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TTSExample extends StatefulWidget {
//   @override
//   State<TTSExample> createState() => _TTSExampleState();
// }

// class _TTSExampleState extends State<TTSExample> {
//   FlutterTts flutterTts = FlutterTts();

//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);

//     await flutterTts.speak(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text-to-Speech Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             speak("Hello, Mr.Denish Gujrati How are You");
//           },
//           child: Text('Speak'),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           speak("Hello, Mr.Denish Gujrati How are You");
//         },
//         child: Icon(Icons.mic),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:http/http.dart' as http;
// import 'dart:ui' as ui;

// import 'package:pdf_render/pdf_render_widgets.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'PDF Save to Gallery'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   PdfDocument? pdfDocument;
//   File? pdfFile;

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 savePdfToGallery();
//               },
//               icon: const Icon(Icons.save))
//         ],
//       ),
//       body: FutureBuilder(
//         future: loadPdf(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             pdfDocument = snapshot.data as PdfDocument;
//             return PdfViewer(doc: pdfDocument!);
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     pdfFile?.delete();
//     super.dispose();
//   }

//   Future<String> tempPdfPath() async {
//     Directory tempDir = await getTemporaryDirectory();
//     final dirExists = await tempDir.exists();

//     if (!dirExists) {
//       await tempDir.create();
//     }

//     String tempPath = tempDir.path;

//     return '$tempPath/my-pdf.pdf';
//   }

//   Future<PdfDocument> loadPdf() async {
//     const pdfUrl = 'https://www.irs.gov/pub/irs-pdf/fw4.pdf';

//     // Fetch the PDF from the URL.
//     final pdfResponse = await http.get(Uri.parse(pdfUrl));
//     final pdfPath = await tempPdfPath();
//     pdfFile = File(pdfPath);
//     pdfFile?.writeAsBytesSync(pdfResponse.bodyBytes);

//     pdfDocument = await PdfDocument.openFile(pdfPath);

//     if (pdfDocument == null) {
//       throw Exception('Unable to open PDF');
//     }

//     return pdfDocument!;
//   }

//   void savePdfToGallery() async {
//     if (pdfDocument == null) {
//       debugPrint('No PDF loaded yet');
//       return;
//     }

//     debugPrint(pdfDocument!.pageCount.toString());

//     for (int i = 1; i <= pdfDocument!.pageCount; i++) {
//       var page = await pdfDocument!.getPage(i);
//       debugPrint('Page $i size: ${page.width} x ${page.height}');

//       // Converting PDF points into pixels for printing.
//       // https://www.gdpicture.com/guides/gdpicture/About%20a%20PDF%20format.html#:~:text=In%20PDF%20documents%2C%20everything%20is,for%20DIN%20A4%20page%20size.
//       //  1 point = 1/72 inch
//       //  72 points per inch
//       // https://printninja.com/printing-resource-center/printninja-file-setup-checklist/offset-printing-guidelines/recommended-resolution/
//       // 300 dpi = 300 pixels per inch
//       final width = (page.width * 300 / 72).ceil();
//       final height = (page.height * 300 / 72).ceil();
//       PdfPageImage pagePdfImage = await page.render(
//           width: width, height: height, allowAntialiasingIOS: true);
//       ui.Image pageImage = await pagePdfImage.createImageDetached();
//       ByteData? imageBytes =
//           await pageImage.toByteData(format: ui.ImageByteFormat.png);

//       if (imageBytes != null) {
//         final result = await ImageGallerySaver.saveImage(
//             imageBytes.buffer.asUint8List(),
//             quality: 100,
//             name: 'page_${i}_${DateTime.now().millisecondsSinceEpoch}');
//         // ignore: unnecessary_brace_in_string_interps
//         debugPrint("${result}");
//       }
//     }
//   }
// }



//gallery crop code

// import 'dart:io';
// import 'dart:ui' as ui;

// import 'package:crop_image/crop_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboard.dart';
// import 'package:pdf_creator/Screens/DashBoard%20Screen/dashboardCtrl.dart';
// import 'package:pdf_creator/Screens/Gallery%20Crop/gallerycropcntl.dart';
// import 'package:pdf_creator/Utilities/colors.dart';
// import 'package:pdf_creator/Utilities/utilities.dart';

// class GalleryCropScreen extends StatefulWidget {
//   const GalleryCropScreen({Key? key, this.images, this.cnt}) : super(key: key);
//   final images;
//   final cnt;

//   @override
//   State<GalleryCropScreen> createState() => _GalleryCropScreenState();
// }

// class _GalleryCropScreenState extends State<GalleryCropScreen> {
//   final _CropCtrl = Get.put(galleryCropCntl());
//   final _focusNode = FocusNode();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final DashCtrl _dashCtrl = Get.put(DashCtrl());

//   List<File> croppedList = [];
//   void _initControllers() {
//     _dashCtrl.nameController.value.clear();
//     _CropCtrl.ImgLst.addAll(widget.images);
//   }

//   @override
//   void initState() {
//     _initControllers();
//     super.initState();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _dashCtrl.nameController.value.selection = TextSelection(
//           baseOffset: 0,
//           extentOffset: _dashCtrl.nameController.value.text.length,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _initControllers();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _dashCtrl.nameController.value.selection = TextSelection(
//           baseOffset: 0,
//           extentOffset: _dashCtrl.nameController.value.text.length,
//         );
//       }
//     });
//     super.dispose();
//   }

//   String formattedTime = DateFormat('hh:mm:ss a').format(DateTime.now());
//   String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: AppColor.themeDark.withOpacity(.3),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         leading: IconButton(
//           tooltip: "Exit",
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColor.themeDark.withOpacity(.7),
//         title: Form(
//           key: formKey,
//           child: Obx(
//             () => Container(
//               margin: EdgeInsets.only(bottom: 3),
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 cursorColor: Colors.white,
//                 cursorHeight: 20,
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(color: Colors.white)),
//                   errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(color: Colors.white)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(color: Colors.white)),
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(color: Colors.white)),
//                   hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
//                   hintText: "Enter PDF Name",
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.white,
//                   ),
//                 ),
//                 focusNode: _focusNode,
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//                 controller: _dashCtrl.nameController.value,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 170,
//             child: Obx(
//               () => ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 itemCount: _CropCtrl.ImgLst.length,
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       _CropCtrl.selectedIndex.value = index;
//                       print('Selected Index: ${_CropCtrl.selectedIndex.value}');
//                       print('ImgLst Length: ${_CropCtrl.ImgLst.length}');
//                     },
//                     child: Padding(
//                       key:
//                           UniqueKey(), // Use UniqueKey for better widget identification
//                       padding: const EdgeInsets.all(8.0),
//                       child: Obx(
//                         () => Container(
//                           width: MediaQuery.of(context).size.width / 3.1,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(.5),
//                                 offset: ui.Offset(.6, .6),
//                                 blurStyle: BlurStyle.outer,
//                                 spreadRadius: .5,
//                                 blurRadius: .9,
//                               ),
//                             ],
//                             border: _CropCtrl.selectedIndex.value == index
//                                 ? Border.all(color: Colors.white)
//                                 : null,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(3.0),
//                             child: Container(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.file(
//                                   File(_CropCtrl.ImgLst[index].path),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.01,
//           ),
//           Obx(() {
//             return Padding(
//               key:
//                   UniqueKey(), // Use UniqueKey for better widget identification
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(.5),
//                       offset: ui.Offset(.6, .6),
//                       blurStyle: BlurStyle.outer,
//                       spreadRadius: .5,
//                       blurRadius: .9,
//                     ),
//                   ],
//                   color: Colors.black.withOpacity(.5),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: (_CropCtrl.selectedIndex < _CropCtrl.ImgLst.length)
//                     ? CropImage(
//                         paddingSize: 25.0,
//                         alwaysMove: true,
//                         controller: _CropCtrl.controller.value,
//                         image: Image.file(File(_CropCtrl
//                             .ImgLst[_CropCtrl.selectedIndex.value].path)),
//                       )
//                     : Center(child: CircularProgressIndicator()),
//               ),
//             );
//           }),
//           // SizedBox(
//           //   height: MediaQuery.of(context).size.height * 0.05,
//           // ),
//           _buildButtons(),
//           ValueListenableBuilder(
//             valueListenable: _CropCtrl.loadingState,
//             builder: (context, isLoading, child) {
//               return AnimatedSize(
//                 duration: kThemeAnimationDuration,
//                 child: isLoading ? child : null,
//               );

//               // return isLoading
//               //     ? CircularProgressIndicator() // Show loading indicator
//               //     : YourActualContent(); // Your actual content when not loading
//             },
//             child: AlertDialog(
//               title: ValueListenableBuilder(
//                 valueListenable: _CropCtrl.loadingState,
//                 builder: (_, bool isLoading, __) => Obx(
//                   () => Text(
//                     isLoading
//                         ? "Exporting video ${(_CropCtrl.progressValue.value.value * 100).ceil()}%"
//                         : "Export complete",
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildButtons() => Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: Icon(
//               Icons.delete_outline_rounded,
//               color: AppColor.whiteClr,
//             ),
//             onPressed: _deleteImage,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.aspect_ratio,
//               color: AppColor.whiteClr,
//             ),
//             onPressed: _aspectRatios,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.rotate_90_degrees_ccw_outlined,
//               color: AppColor.whiteClr,
//             ),
//             onPressed: _rotateLeft,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.close,
//               color: AppColor.whiteClr,
//             ),
//             onPressed: () {
//               _CropCtrl.controller.value.rotation = CropRotation.up;
//               _CropCtrl.controller.value.crop =
//                   const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
//               _CropCtrl.controller.value.aspectRatio = 1.0;
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.rotate_90_degrees_cw_outlined,
//               color: AppColor.whiteClr,
//             ),
//             onPressed: _rotateRight,
//           ),
//           TextButton(
//             onPressed: () {
//               _finished(context);
//             },
//             child: Text(
//               'Done',
//               style: TextStyle(
//                 color: AppColor.whiteClr,
//               ),
//             ),
//           ),
//         ],
//       );

//   Future<void> _aspectRatios() async {
//     final value = await showDialog<double>(
//       context: context,
//       builder: (context) {
//         return SimpleDialog(
//           title: const Text('Select aspect ratio'),
//           children: [
//             // special case: no aspect ratio
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, -1.0),
//               child: const Text('free'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, 1.0),
//               child: const Text('square'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, 2.0),
//               child: const Text('2:1'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, 1 / 2),
//               child: const Text('1:2'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, 4.0 / 3.0),
//               child: const Text('4:3'),
//             ),
//             SimpleDialogOption(
//               onPressed: () => Navigator.pop(context, 16.0 / 9.0),
//               child: const Text('16:9'),
//             ),
//           ],
//         );
//       },
//     );
//     if (value != null) {
//       _CropCtrl.controller.value.aspectRatio = value == -1 ? null : value;
//       _CropCtrl.controller.value.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
//     }
//   }

//   Future<void> _rotateLeft() async => _CropCtrl.controller.value.rotateLeft();

//   Future<void> _rotateRight() async => _CropCtrl.controller.value.rotateRight();

//   Future<void> _deleteImage() async {
//     LoadingDialog.show(context);

//     if (croppedList.isNotEmpty && _CropCtrl.ImgLst.length == 1) {
//       if (_dashCtrl.nameController.value.text.trim().isNotEmpty &&
//           _CropCtrl.ImgLst.length == 1) {
//         await _dashCtrl.saveDocument(
//           imageList: croppedList,
//           name: _dashCtrl.nameController.value.text.trim(),
//           documentPath: croppedList[0].path,
//           dateTime: '$formattedDate $formattedTime',
//         );
//         Get.offAll(() => DashBoard());
//         // No need to Get.offAll here, as it will be handled in _finished
//       } else {
//         LoadingDialog.hide(context);
//         ErrorSnackbar().showSnackbar(context, "Please Enter Name");
//         return; // Return to avoid further execution of the method
//       }
//     } else {
//       Get.back();
//     }

//     if (croppedList.isEmpty && _CropCtrl.ImgLst.length == 1) {
//       Get.back();
//     }

//     if (_CropCtrl.ImgLst.length > 1) {
//       _CropCtrl.ImgLst.removeAt(_CropCtrl.selectedIndex.value);
//     }

//     if (_dashCtrl.nameController.value.text.trim().isNotEmpty &&
//         _CropCtrl.ImgLst.length == 0) {
//       _CropCtrl.ImgLst.removeAt(_CropCtrl.selectedIndex.value);
//       Get.back();
//     }

//     if (_CropCtrl.selectedIndex.value > 0) {
//       _CropCtrl.selectedIndex.value = _CropCtrl.selectedIndex.value - 1;
//     }
//   }

//   Future<void> _finished(BuildContext context) async {
//     try {
//       _CropCtrl.loadingState.value = true;
//       // LoadingDialog.show(context);
//       ui.Image bitmap = await _CropCtrl.controller.value.croppedBitmap();
//       var data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
//       var bytes = data!.buffer.asUint8List();
//       Directory tempDir = await getTemporaryDirectory();
//       File file =
//           File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
//       await file.writeAsBytes(bytes);

//       if (_CropCtrl.selectedIndex.value < _CropCtrl.ImgLst.length) {
//         if (_dashCtrl.nameController.value.text.trim().isNotEmpty ||
//             _CropCtrl.ImgLst.length != 1) {
//           croppedList.add(file);
//           // LoadingDialog.hide(context);
//           _CropCtrl.ImgLst.removeAt(_CropCtrl.selectedIndex.value);
//         } else {
//           // LoadingDialog.hide(context);
//           ErrorSnackbar().showSnackbar(context, "Please Enter Name");
//         }
//       }

//       if (_CropCtrl.ImgLst.isNotEmpty) {
//         _CropCtrl.selectedIndex.value = 0;
//       }

//       if (_CropCtrl.ImgLst.isEmpty && _CropCtrl.selectedIndex.value == 0) {
//         _CropCtrl.progressValue.value.value = 0.5;
//         Get.offAll(() => DashBoard());
//         await _dashCtrl.saveDocument(
//           imageList: croppedList,
//           name: _dashCtrl.nameController.value.text.trim(),
//           documentPath: croppedList[0].path,
//           dateTime: '$formattedDate $formattedTime',
//         );
//       }
//     } catch (e) {
//       print('Error while cropping image: $e');
//     } finally {
//       _CropCtrl.loadingState.value =
//           false; // Set loading state to false when finished
//     }
//   }
// }