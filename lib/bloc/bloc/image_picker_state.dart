part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImagePickerLoadedState extends ImagePickerState {
  final List<CImage> images;

  ImagePickerLoadedState(this.images);
  @override
  List<Object?> get props => [images];
}

class ImagePickerLoadingState extends ImagePickerState {}

class ImagePickerInitialState extends ImagePickerState {}

class ImagePickerQualityState extends ImagePickerState {
  final int imageQuality;

  ImagePickerQualityState(this.imageQuality);
}

class ImagePickerErrorState extends ImagePickerState {
  final String errorMessage;

  ImagePickerErrorState(this.errorMessage);
}
