import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerLoadedState(const [])) {
    on<MutlipleSelectImageEvent>((event, emit) {
      emit(ImagePickerLoadedState(event.images));
    });

    on<MutlipleSelectImageLoadingEvent>((event, emit) {
      emit(ImagePickerLoadingState());
    });
  }
}
