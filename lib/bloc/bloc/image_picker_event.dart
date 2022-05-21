part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class ImagePickerSelectEvent extends ImagePickerEvent {
  final List<CImage> images;
  const ImagePickerSelectEvent({
    required this.images,
  });
}

class ImagePickerLoadingEvent extends ImagePickerEvent {}

class ImagePickerResetEvent extends ImagePickerEvent {}

class ImagePickerSetQualityEvent extends ImagePickerEvent {
  final int imageQuality;

  const ImagePickerSetQualityEvent(this.imageQuality);
}
