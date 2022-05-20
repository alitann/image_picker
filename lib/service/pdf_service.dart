import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import '../extensions/context_extension.dart';
import '../model/collage_image.dart';

abstract class IPdfService {
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> selectedImages);
  void showPdf(File file);
}

class PdfService extends IPdfService {
// class PdfService {
  late List<CImage> imageList;

  @override
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> selectedImages) async {
    imageList = selectedImages;

    final pdf = pw.Document();

    DateTime now = DateTime.now();
    String currentDate = DateFormat('dd.MM.yyyy HH:mm:ss').format(now);

    final double imageWidth = (contextMain.width - contextMain.lowValue) / 2;

    final double imageHeight = (contextMain.height - (contextMain.highValue * 2)) / 2;
    final double pageCount = imageList.length % 4 == 0 ? imageList.length / 4 : imageList.length ~/ 4 + 1;

    int pageNumber;
    for (pageNumber = 1; pageNumber <= pageCount; pageNumber++) {
      pdf.addPage(_buildPdfPageHeader(imageWidth, imageHeight, contextMain, pageNumber)); // Page
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var filePath = '$appDocPath/$currentDate.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Page _buildPdfPageHeader(double imageWidth, double imageHeight, BuildContext contextMain, int pageNumber) {
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        clip: false,
        build: (pw.Context context) {
          return _buildPage(imageWidth, imageHeight, contextMain, pageNumber);
        });
  }

  pw.Center _buildPage(double imageWidth, double imageHeight, BuildContext contextMain, int pageNumber) {
    return pw.Center(
      child: _buildPdfColumn(imageWidth, imageHeight, contextMain, pageNumber),
    );
  }

  pw.Column _buildPdfColumn(double imageWidth, double imageHeight, BuildContext contextMain, int pageNumber) {
    return pw.Column(children: [
      ...getColumnWidgetContent(
          pageNumber: pageNumber, imageWidth: imageWidth, imageHeight: imageHeight, contextMain: contextMain)
    ]);
  }

  List<pw.Widget> getColumnWidgetContent(
      {required int pageNumber,
      required double imageWidth,
      required double imageHeight,
      required BuildContext contextMain}) {
    List<pw.Widget> list = [];

    for (var index = 1; index <= 2; index++) {
      list.add(_buildPdfRow(pageNumber, index, imageWidth, imageHeight, contextMain));
      if (index % 2 == 1) list.add(pw.SizedBox(height: 20));
    }
    return list;
  }

  List<pw.Widget> getRowWidgetContent(
      int pageNumber, int columnIndex, double imageWidth, double imageHeight, BuildContext contextMain) {
    List<pw.Widget> list = [];

    for (var index = 1; index <= 2; index++) {
      list.add(_buildPdfImage(pageNumber, index, columnIndex, imageWidth, imageHeight) ??
          pw.SizedBox(width: imageWidth, height: imageHeight));
      if (index % 2 == 1) list.add(pw.SizedBox(width: contextMain.lowValue));
    }
    return list;
  }

  pw.Row _buildPdfRow(
      int pageNumber, int columnIndex, double imageWidth, double imageHeight, BuildContext contextMain) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      mainAxisSize: pw.MainAxisSize.min,
      children: [...getRowWidgetContent(pageNumber, columnIndex, imageWidth, imageHeight, contextMain)],
    );
  }

  pw.Image? _buildPdfImage(int pageNumber, int rowIndex, int columnIndex, double imageWidth, double imageHeight) {
    int imageOrderOnPage = columnIndex == 2 ? columnIndex + rowIndex : rowIndex;
    int imageOrder = pageNumber == 1 ? imageOrderOnPage : imageOrderOnPage + 4 * (pageNumber - 1);

    if (imageOrder > imageList.length) {
      return null;
    } else {
      final image = pw.MemoryImage(
        File(imageList[imageOrder - 1].path).readAsBytesSync(),
      );

      return pw.Image(image, width: imageWidth, height: imageHeight, fit: pw.BoxFit.cover);
    }
  }

  @override
  void showPdf(File file) {
    PdfView(path: file.path);
  }
}
