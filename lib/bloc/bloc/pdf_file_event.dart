part of 'pdf_file_bloc.dart';

abstract class PdfFileEvent extends Equatable {
  const PdfFileEvent();

  @override
  List<Object> get props => [];
}

class PdfFileCreateRequest extends PdfFileEvent {
  final List<CImage> imageList;
  final BuildContext context;

  const PdfFileCreateRequest(this.imageList, this.context);
}

class PdfFileResetRequest extends PdfFileEvent {}
