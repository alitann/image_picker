import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfViewerView extends StatelessWidget {
  const PdfViewerView({Key? key, required this.title, required this.pdfFile}) : super(key: key);
  final String title;
  final File pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: PdfView(path: pdfFile.path),
      ),
    );
  }
}
