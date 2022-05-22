import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/collage_image.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitialState()) {
    on<ImagePickerSelectEvent>((event, emit) {
      try {
        emit(ImagePickerLoadingState());

        emit(ImagePickerLoadedState(event.images));
      } catch (e) {
        emit(ImagePickerErrorState(e.toString()));
      }
    });

    on<ImagePickerLoadingEvent>((event, emit) {
      emit(ImagePickerLoadingState());
    });

    on<ImagePickerResetEvent>((event, emit) {
      emit(ImagePickerInitialState());
    });

    on<ImagePickerSetQualityEvent>((event, emit) {
      emit(ImagePickerInitialState());

      emit(ImagePickerQualityState(event.imageQuality));
    });
  }
}
