import 'dart:io';

import 'package:flutter/material.dart';

import '../model/collage_image.dart';
import '../service/pdf_service.dart';

abstract class IPdfRepository {
  final IPdfService pdfService;

  IPdfRepository(this.pdfService);

  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> imageList);
  void showPdf(File file);
}

class PdfRepository extends IPdfRepository {
  PdfRepository(super.pdfService);
  @override
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> imageList) async {
    return await pdfService.createPdfFile(contextMain, imageList);
  }

  @override
  void showPdf(File file) {
    pdfService.showPdf(file);
  }
}
