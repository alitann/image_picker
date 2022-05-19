import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_collage/model/collage_image.dart';
import 'package:image_collage/service/pdf_service.dart';

abstract class IPdfRepository {
  final PdfService pdfService;

  IPdfRepository(this.pdfService);
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> imageList);
  Future<void> showPdf(File file);
}

class PdfRepository extends IPdfRepository {
  PdfRepository(super.pdfService);

  @override
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> imageList) async {
    return await pdfService.createPdfFile(contextMain, imageList);
  }

  @override
  Future<void> showPdf(File file) async {
    await pdfService.showPdf(file);
  }
}
