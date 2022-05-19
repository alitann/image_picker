import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/collage_image.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitialState()) {
    on<MutlipleSelectImageEvent>((event, emit) {
      emit(ImagePickerLoadedState(event.images));
    });

    on<MutlipleSelectImageLoadingEvent>((event, emit) {
      emit(ImagePickerLoadingState());
    });

    on<MutlipleSelectImageResetEvent>((event, emit) {
      emit(ImagePickerInitialState());
    });
  }
}
