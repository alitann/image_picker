import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/application_constants.dart';
import '../../model/collage_image.dart';
import '../../repository/pdf_repository.dart';

part 'pdf_file_event.dart';
part 'pdf_file_state.dart';

class PdfFileBloc extends Bloc<PdfFileEvent, PdfFileState> {
  final IPdfRepository pdfRepository;
  PdfFileBloc(this.pdfRepository) : super(PdfFileInitial()) {
    on<PdfFileCreateRequest>((event, emit) async {
      try {
        emit(PdfFileLoading());

        if (event.imageList.isEmpty) {
          emit(const PdfFileError(ApplicationConstants.minImageError));
        } else {
          File? pdfFile = await pdfRepository.createPdfFile(event.context, event.imageList);
          emit(PdfFileCreated(pdfFile));
        }
      } catch (e) {
        emit(PdfFileError(e.toString()));
      }
    });

    on<PdfFileResetRequest>((event, emit) async {
      emit(PdfFileInitial());
    });
  }
}
