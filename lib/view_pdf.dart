import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class view_pdf extends StatefulWidget {
  String path;
  view_pdf({super.key, required this.path});

  @override
  State<view_pdf> createState() => _view_pdfState();
}

class _view_pdfState extends State<view_pdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(File(widget.path)),
    );
  }
}

// class view_pdf extends StatelessWidget {
//   String path;
//   view_pdf({super.key, required this.path});
//   @override
//   Widget build(BuildContext context) {
//     return PDFViewerScaffold(
//         //view PDF
//         appBar: AppBar(
//           title: Text("Document"),
//           backgroundColor: Colors.deepOrangeAccent,
//         ),
//         path: path);
//   }
// }
