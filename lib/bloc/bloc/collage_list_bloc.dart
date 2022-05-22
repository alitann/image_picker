import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';

import '../../repository/storage_repository.dart';

part 'collage_list_event.dart';
part 'collage_list_state.dart';

class CollageListBloc extends Bloc<CollageListEvent, CollageListState> {
  final IStorageRepository storageRepository;

  CollageListBloc(this.storageRepository) : super(CollageListInitial()) {
    on<CollageListLoadEvent>((event, emit) async {
      try {
        emit(CollageListLoading());

        emit(CollageListLoaded(imagePdfFiles: await storageRepository.getLocalFileList()));
      } catch (e) {
        emit(CollageListError(e.toString()));
      }
    });

    on<CollageListDeleteEvent>((event, emit) async {
      try {
        emit(CollageListLoading());
        int result = await storageRepository.deleteFile(event.file);

        if (result == 1) {
          emit(CollageListDeleted());
          emit(CollageListLoaded(imagePdfFiles: await storageRepository.getLocalFileList()));
        } else {
          emit(const CollageListError(ApplicationConstants.deleteFileError));
        }
      } catch (e) {
        emit(CollageListError(e.toString()));
      }
    });
  }
}
