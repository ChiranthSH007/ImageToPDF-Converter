import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgtopdf/colors.dart';
import 'package:imgtopdf/list_page.dart';
import 'package:imgtopdf/mainpage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfget;
import 'package:permission_handler/permission_handler.dart';

class Create_pdf extends StatefulWidget {
  const Create_pdf({super.key});

  @override
  State<Create_pdf> createState() => _Create_pdfState();
}

class _Create_pdfState extends State<Create_pdf> {
  final picker = ImagePicker();
  final pdf = pdfget.Document();
  List<File>? images = [];
  String fname = "";
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create PDF"),
          centerTitle: true,
          backgroundColor: secondary,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  getImages();
                },
                icon: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.redAccent,
                ))
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: ,
        // ),
        backgroundColor: secondary,
        body: Column(
          children: [
            _loading == false
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                fname = text.trim();
                              });
                            },
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: white),
                            decoration: const InputDecoration(
                              focusColor: primary,
                              fillColor: primary,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                              labelText: 'File Name',
                              labelStyle: TextStyle(color: Colors.yellow),
                              hintText: 'Enter File Name',
                              hintStyle: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 600,
                          child: images?.isEmpty == false
                              ? ListView.builder(
                                  itemCount: images?.length,
                                  itemBuilder: (context, index) => Container(
                                        height: 500,
                                        width: double.infinity,
                                        margin: EdgeInsets.all(8),
                                        child: Image.file(
                                          images![index],
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                              : Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Add Pages",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return primary.withOpacity(0.04);
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed))
                        return primary.withOpacity(0.12);
                      return null; // Defer to the widget's default.
                    },
                  ), // foreground
                ),
                onPressed: () {
                  if (fname == "") {
                    _showToast("Enter The File Name");
                  } else {
                    _loading = true;
                    createPdf();
                    savePdf();
                  }
                },
                child: const Text(
                  'Create PDF',
                  style: TextStyle(color: black),
                ),
              ),
            )
          ],
        ));
  }

  _showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  getImages() async {
    List<XFile> pickedImage = await picker.pickMultiImage();
    setState(() {
      if (pickedImage != null) {
        for (var i = 0; i < pickedImage.length; i++) {
          images?.add(File(pickedImage[i].path));
        }
      } else {
        print("no Image Selected");
      }
    });
  }

  createPdf() async {
    for (var img in images!) {
      final Image = pdfget.MemoryImage(img.readAsBytesSync());
      pdf.addPage(pdfget.Page(
        pageFormat: PdfPageFormat.undefined,
        build: (pdfget.Context context) {
          return pdfget.Center(child: pdfget.Image(Image));
        },
      ));
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  savePdf() async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            // access media location needed for android 10/Q
            await _requestPermission(Permission.accessMediaLocation) &&
            // manage external storage needed for android 11/R
            await _requestPermission(Permission.manageExternalStorage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/IMGtoPDFApp";
          directory = Directory(newPath);
          print(directory);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        final file = File("${directory.path}/" + fname + ".pdf");
        await file.writeAsBytes(await pdf.save()).then((value) => setState(() {
              _loading = false;

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Main_Page()));
            }));
      }
    } catch (e) {
      print(e.toString() + "ERRRRROOOOOORRRRR");
    }
  }
}
