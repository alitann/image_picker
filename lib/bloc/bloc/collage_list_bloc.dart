import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/repository/storage_repository.dart';
import 'package:path_provider/path_provider.dart';

part 'collage_list_event.dart';
part 'collage_list_state.dart';

class CollageListBloc extends Bloc<CollageListEvent, CollageListState> {
  final IStorageRepository storageRepository;

  CollageListBloc(this.storageRepository) : super(CollageListInitial()) {
    on<CollageListLoadEvent>((event, emit) async {
      try {
        emit(CollageListLoading());

        emit(CollageListLoaded(imagePdfFiles: await getFileList()));
      } catch (e) {
        emit(CollageListError(e.toString()));
      }
    });

    on<CollageListDeleteEvent>((event, emit) async {
      try {
        emit(CollageListLoading());
        int result = await storageRepository.deleteFile(event.file);

        if (result == 1) {
          emit(CollageListLoaded(imagePdfFiles: await getFileList()));
        }
      } catch (e) {
        emit(CollageListError(e.toString()));
      }
    });
  }

  Future<List<File>> getFileList() async {
    List<File> collagePdfList;

    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> localFileList = Directory(directory.path).listSync();

    collagePdfList = localFileList.whereType<File>().toList();
    collagePdfList.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return collagePdfList;
  }
}
