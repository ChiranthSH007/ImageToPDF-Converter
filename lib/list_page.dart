// ignore_for_file: unnecessary_new

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgtopdf/colors.dart';
import 'package:imgtopdf/createpdf.dart';
import 'package:imgtopdf/view_pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfget;
import 'package:permission_handler/permission_handler.dart';

class List_Page extends StatefulWidget {
  const List_Page({super.key});

  @override
  State<List_Page> createState() => _List_PageState();
}

class _List_PageState extends State<List_Page> {
  late List<FileSystemEntity> _folders;
  bool dstatus = false;
  @override
  void initState() {
    super.initState();
    getDir();
  }

  onGoBack(dynamic value) {
    getDir();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondary,
        body: dstatus == false
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: _folders.isEmpty == false
                    ? ListView.builder(
                        itemCount: _folders.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              OpenFilex.open(_folders[index].path.toString());
                              // Navigator.of(context)
                              //     .push(
                              //       new PageRouteBuilder(
                              //         pageBuilder: (_, __, ___) => new view_pdf(
                              //             path:
                              //                 _folders[index].path.toString()),
                              //         transitionsBuilder: (context, animation,
                              //                 secondaryAnimation, child) =>
                              //             new FadeTransition(
                              //                 opacity: animation, child: child),
                              //       ),
                              //     )
                              //     .then(onGoBack);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: primary,
                                child: ListTile(
                                    leading: const Icon(
                                      Icons.save,
                                      color: Colors.yellow,
                                    ),
                                    title: Text(
                                        style: const TextStyle(color: white),
                                        _folders[index].path.split('/').last),
                                    trailing: IconButton(
                                      highlightColor: red,
                                      icon: const Icon(Icons.delete),
                                      color: Colors.redAccent,
                                      onPressed: () async {
                                        _showMyDialog(index);
                                      },
                                    )),
                              ),
                            ),
                          );
                        })
                    : const Center(
                        child: Text(
                        "No Doucments Found",
                        style: TextStyle(color: white),
                      )),
              )
            : const Center(child: CircularProgressIndicator()));
  }

  Future<void> _showMyDialog(index) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary,
          title: const Text(
            'Delete Document',
            style: TextStyle(color: white),
          ),
          content: const Text(
            'Do u want to Delete the Document ?',
            style: TextStyle(color: grey),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: const Text(
                'Yes',
                style: TextStyle(color: white),
              ),
              onPressed: () async {
                setState(() {
                  dstatus = true;
                });
                await _folders[index].delete().then((value) => setState(() {
                      dstatus = false;
                      getDir();
                      Navigator.of(context).pop();
                    }));
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: const Text(
                'No',
                style: TextStyle(color: white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  Future<void> getDir() async {
    String pdfDirectory = '/storage/emulated/0/IMGtoPDFApp';
    final myDir = new Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    setState(() {});
    print(_folders);
  }

  //await _folders[index].delete() to delete file

}
