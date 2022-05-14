part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class MutlipleSelectImageEvent extends ImagePickerEvent {
  final List<XFile?> images;
  const MutlipleSelectImageEvent({
    required this.images,
  });
}

class MutlipleSelectImageLoadingEvent extends ImagePickerEvent {}
