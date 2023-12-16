import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DocumentModel {
  String name;
  String shareLink;
  String documentPath;
  String dateTime;
  String pdfPath;
  DocumentModel(
      {required this.name,
      this.shareLink = "",
      required this.documentPath,
      required this.dateTime,
      required this.pdfPath});
}

class getCamera {
  static const MethodChannel _channel =
      MethodChannel('cunning_document_scanner');

  /// Call this to start get Picture workflow.
  static Future<List<String>?> getPictures(bool crop) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) ||
        statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    final List<dynamic>? pictures =
        await _channel.invokeMethod('getPictures', {'crop': crop});

    return pictures?.map((e) => e as String).toList();
  }
}

class CunningDocumentScanner {
  static const MethodChannel _channel =
      MethodChannel('cunning_document_scanner');

  /// Call this to start get Picture workflow.
  static Future<List<String>?> getPictures(bool crop) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) ||
        statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    final List<dynamic>? pictures =
        await _channel.invokeMethod('getPictures', {'crop': crop});
    return pictures?.map((e) => e as String).toList();
  }
}

class getGallery {
  static const MethodChannel _channel =
      MethodChannel('cunning_document_scanner');

  static Future<List<String>?> getPictures(bool crop) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) ||
        statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    final ImagePicker _picker = ImagePicker();

    final List<XFile>? pictures = await _picker.pickMultiImage();

    if (pictures == null) {
      throw Exception("No images selected");
    }

    return pictures.map((e) => e.path).toList();
  }
}


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<File?> _selectedImages = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select & Crop Image'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 20.0),
//             _selectedImages.isEmpty
//                 ? Image.asset('assets/images/onboardingone.jpg', height: 300.0, width: 300.0,)
//                 : SizedBox(
//                     height: 300.0,
//                     width: 300.0,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _selectedImages.length,
//                       itemBuilder: (context, index) {
//                         return _selectedImages[index] != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(150.0),
//                                 child: Image.file(_selectedImages[index]!, fit: BoxFit.fill),
//                               )
//                             : Container();
//                       },
//                     ),
//                   ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () async {
//                 Map<Permission, PermissionStatus> statuses = await [
//                   Permission.storage,
//                   Permission.camera,
//                 ].request();
//                 if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
//                   showImagePicker(context);
//                 } else {
//                   print('No permission provided');
//                 }
//               },
//               child: Text('Select Images'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   final picker = ImagePicker();

//   void showImagePicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Card(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 5.2,
//             margin: const EdgeInsets.only(top: 8.0),
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     child: Column(
//                       children: const [
//                         Icon(Icons.image, size: 60.0),
//                         SizedBox(height: 12.0),
//                         Text(
//                           "Gallery",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       _imgFromGallery();
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     child: SizedBox(
//                       child: Column(
//                         children: const [
//                           Icon(Icons.camera_alt, size: 60.0),
//                           SizedBox(height: 12.0),
//                           Text(
//                             "Camera",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                     onTap: () {
//                       _imgFromCamera();
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   _imgFromGallery() async {
//     List<XFile>? result = await picker.pickMultiImage(
//       imageQuality: 50,
//     );
//     if (result != null) {
//       for (var image in result) {
//         _cropImage(File(image.path));
//       }
//     }
//   }

//   _imgFromCamera() async {
//     XFile? result = await picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 50,
//     );
//     if (result != null) {
//       _cropImage(File(result.path));
//     }
//   }

//   _cropImage(File imgFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: imgFile.path,
//       aspectRatioPresets: Platform.isAndroid
//           ? [
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio16x9,
//             ]
//           : [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio5x3,
//               CropAspectRatioPreset.ratio5x4,
//               CropAspectRatioPreset.ratio7x5,
//               CropAspectRatioPreset.ratio16x9,
//             ],
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: "Image Cropper",
//           toolbarColor: Colors.deepOrange,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(
//           title: "Image Cropper",
//         )
//       ],
//     );

//     if (croppedFile != null) {
//       setState(() {
//         _selectedImages.add(File(croppedFile.path));
//       });
//     }
//   }
// }
