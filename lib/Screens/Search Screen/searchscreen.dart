import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf_creator/Screens/pdfscreen/pdfscreen.dart';
import 'package:pdf_creator/model/documentmodel.dart';
import 'package:pdf_creator/provider/documentprovider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
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
    // TODO: implement buildLeading
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
    // TODO: implement buildResults
    if (query.isEmpty) {
      List<DocumentModel> documentList = getAllDocuments(context);
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFScreen(
                  document: documentList[index],
                ),
              ));
            },
            leading: Image.file(File(documentList[index].documentPath)),
            title: Text(documentList[index].name),
            subtitle: Text(
                "${documentList[index].dateTime.day.toString()}/${documentList[index].dateTime.month.toString()}/${documentList[index].dateTime.year.toString()}"),
          ),
        ),
        itemCount: documentList.length - 1,
      );
    } else {
      List<DocumentModel> documentList = getAllDocuments(context)
          .where((element) => element.name.startsWith(query))
          .toList();
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFScreen(document: documentList[index]),
              ));
            },
            leading: Image.file(new File(documentList[index].documentPath)),
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
            subtitle: Text(
                "${documentList[index].dateTime.day.toString()}/${documentList[index].dateTime.month.toString()}/${documentList[index].dateTime.year.toString()}"),
          ),
        ),
        itemCount: documentList.length,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      List<DocumentModel> documentList = getAllDocuments(context);
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
            subtitle: Text(
                "${documentList[index].dateTime.day.toString()}/${documentList[index].dateTime.month.toString()}/${documentList[index].dateTime.year.toString()}"),
          ),
        ),
        itemCount: documentList.length - 1,
      );
    } else {
      List<DocumentModel> documentList = getAllDocuments(context)
          .where((element) => element.name.startsWith(query))
          .toList();
      return ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFScreen(document: documentList[index]),
              ));
            },
            leading: Image.file(new File(documentList[index].documentPath)),
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
            subtitle: Text(
                "${documentList[index].dateTime.day.toString()}/${documentList[index].dateTime.month.toString()}/${documentList[index].dateTime.year.toString()}"),
          ),
        ),
        itemCount: documentList.length,
      );
    }
  }
}

List<DocumentModel> getAllDocuments(BuildContext context) {
  return Provider.of<DocumentProvider>(context).allDocuments;
}
