import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';

import '../../Utilities/classes.dart';
import '../DashBoard Screen/dashboardCtrl.dart';

class Search extends SearchDelegate {
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  final DashCtrl _dashCtrl = Get.put(DashCtrl());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      List<DocumentModel> documentList = _dashCtrl.allDocuments;
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PDFScreen(document: documentList[index], index: index),
              ));
            },
            leading: Image.file(File(documentList[index].documentPath)),
            title: Text(documentList[index].name),
            subtitle: Text(_dashCtrl.allDocuments[index].dateTime),
          ),
        ),
        itemCount: documentList.length,
      );
    } else {
      List<DocumentModel> documentList = getAllDocuments(context, _dashCtrl)
          .where((element) => element.name.startsWith(query))
          .toList();
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PDFScreen(document: documentList[index], index: index),
                ));
              },
              leading: Image.file(File(documentList[index].documentPath)),
              title: RichText(
                text: TextSpan(
                    text: documentList[index].name.substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text:
                              documentList[index].name.substring(query.length),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal))
                    ]),
              ),
              subtitle: Text(_dashCtrl.allDocuments[index].dateTime)),
        ),
        itemCount: documentList.length,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      List<DocumentModel> documentList = getAllDocuments(context, _dashCtrl);
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PDFScreen(document: documentList[index], index: index),
                ));
              },
              leading: Container(
                height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.width * .17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(documentList[index].documentPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(documentList[index].name),
              subtitle: Text(_dashCtrl.allDocuments[index].dateTime)),
        ),
        itemCount: documentList.length,
      );
    } else {
      List<DocumentModel> documentList = getAllDocuments(context, _dashCtrl)
          .where((element) => element.name.startsWith(query))
          .toList();
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PDFScreen(document: documentList[index], index: index),
              ));
            },
            leading: Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .17,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(documentList[index].documentPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: RichText(
              text: TextSpan(
                  text: documentList[index].name.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: documentList[index].name.substring(query.length),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal))
                  ]),
            ),
            subtitle: Text(_dashCtrl.allDocuments[index].dateTime),
          ),
        ),
        itemCount: documentList.length,
      );
    }
  }
}

List<DocumentModel> getAllDocuments(BuildContext context, dashCtrl) {
  return dashCtrl.allDocuments;
}
