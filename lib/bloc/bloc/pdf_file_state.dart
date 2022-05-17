part of 'pdf_file_bloc.dart';

abstract class PdfFileState extends Equatable {
  const PdfFileState();

  @override
  List<Object> get props => [];
}

class PdfFileInitial extends PdfFileState {}

class PdfFileLoading extends PdfFileState {}

class PdfFileCreated extends PdfFileState {
  final Future<File?> pdfFile;

  const PdfFileCreated(this.pdfFile);
}

class PdfFileError extends PdfFileState {
  final String errorMessage;

  const PdfFileError(this.errorMessage);
}
