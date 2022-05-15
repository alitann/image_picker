// import 'package:image_collage/model/collage_image.dart';

// import 'package:pdf/widgets.dart' as pw;

// class CollageImageViewModel {
//   final List<CollageImage> images;
//   CollageImageViewModel(this.images);

//   final pdf = pw.Document();

//   // Future<File> createPdfFile() async {
//   //   final image = pw.MemoryImage(
//   //     File(images[0].path).readAsBytesSync(),
//   //   );

//   //   // pdf.addPage(pw.Page(build: (pw.Context context) {
//   //   //   return pw.Center(
//   //   //     child: pw.Image(image),
//   //   //   ); // Center
//   //   // })); // Page

//   //   pdf.addPage(pw.Page(
//   //       pageFormat: PdfPageFormat.a4,
//   //       clip: true,
//   //       build: (pw.Context context) {
//   //         return pw.Column(children: [
//   //           pw.Row(
//   //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //             mainAxisSize: pw.MainAxisSize.min,
//   //             children: [
//   //               pw.Image(image, width: 500, height: 300),
//   //               pw.SizedBox(width: 100),
//   //               pw.Image(image, width: 500, height: 300),
//   //             ],
//   //           ),
//   //           pw.SizedBox(height: 100),
//   //           pw.Row(
//   //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //             mainAxisSize: pw.MainAxisSize.min,
//   //             children: [
//   //               pw.Image(image, width: 500, height: 300),
//   //               pw.SizedBox(width: 100),
//   //               pw.Image(image, width: 500, height: 300),
//   //             ],
//   //           ),
//   //         ]);
//   //       })); // Page

//   //   Directory appDocDir = await getApplicationDocumentsDirectory();
//   //   String appDocPath = appDocDir.path;

//   //   var filePath = '$appDocPath/example.pdf';
//   //   final file = File(filePath);
//   //   await file.writeAsBytes(await pdf.save());
//   //   // await OpenDocument.openDocument(filePath: filePath);
//   //   // showPdf(file);
//   //   return file;
//   // }

//   // Future<void> showPdf(File file) async {
//   //   PdfView(path: file.path);
//   // }
// }
