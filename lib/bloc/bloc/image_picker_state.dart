part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {}

class ImagePickerLoadedState extends ImagePickerState {
  final List<CImage> images;

  ImagePickerLoadedState(this.images);

  @override
  List<Object?> get props => [images];
}

class ImagePickerLoadingState extends ImagePickerState {
  @override
  List<Object?> get props => [];
}
