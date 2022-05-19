import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';
import 'package:image_collage/model/collage_image.dart';
import 'package:image_collage/repository/pdf_repository.dart';

part 'pdf_file_event.dart';
part 'pdf_file_state.dart';

class PdfFileBloc extends Bloc<PdfFileEvent, PdfFileState> {
  final IPdfRepository pdfRepository;
  PdfFileBloc(this.pdfRepository) : super(PdfFileInitial()) {
    on<PdfFileCreateRequest>((event, emit) async {
      try {
        if (event.imageList.isEmpty) {
          emit(const PdfFileError(ApplicationConstants.minImageError));
        } else {
          emit(PdfFileLoading());
          Future<File?> pdfFile = pdfRepository.createPdfFile(event.context, event.imageList);
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
