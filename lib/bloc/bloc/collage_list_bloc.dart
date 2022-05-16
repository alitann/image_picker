import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/service/storage_service.dart';
import 'package:path_provider/path_provider.dart';

part 'collage_list_event.dart';
part 'collage_list_state.dart';

class CollageListBloc extends Bloc<CollageListEvent, CollageListState> {
  final StorageService storageService;

  CollageListBloc(this.storageService) : super(CollageListInitial()) {
    on<CollageListLoadEvent>((event, emit) async {
      List<File> collageImageList;

      try {
        emit(CollageListLoading());

        final directory = await getApplicationDocumentsDirectory();

        List<FileSystemEntity> localFileList = Directory(directory.path).listSync();

        // collageImageList = storageService.getLocalFileList().whereType<File>().toList();
        collageImageList = localFileList.whereType<File>().toList();
        emit(CollageListLoaded(imagePdfFiles: collageImageList));
      } catch (e) {
        emit(CollageListError(e.toString()));
      }
    });
  }
}
