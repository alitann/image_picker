import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_collage/bloc/bloc/image_picker_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';
import 'package:image_collage/model/collage_image.dart';

class MockImagePickerBloc extends MockBloc<ImagePickerEvent, ImagePickerState> implements ImagePickerBloc {}

void main() {
  setUpAll(() {});

  final images = [CollageImage(path: 'fakePath')];

  group('MockImagePickerBloc Listen with stream', () {
    test("Mock the MockImagePickerBloc's stream!", () {
      final bloc = MockImagePickerBloc();
      whenListen(bloc, Stream.fromIterable([ImagePickerLoadingState(), ImagePickerLoadedState(images)]));
      expectLater(
          bloc.stream, emitsInOrder(<ImagePickerState>[ImagePickerLoadingState(), ImagePickerLoadedState(images)]));
    });

    test("Mock the MockImagePickerBloc's stream!", () {
      final bloc = MockImagePickerBloc();
      whenListen(
          bloc,
          Stream.fromIterable([
            ImagePickerInitialState(),
            ImagePickerLoadingState(),
            ImagePickerLoadedState(images),
            ImagePickerQualityState(100),
            ImagePickerErrorState(ApplicationConstants.blocTestError)
          ]));
      expectLater(
          bloc.stream,
          emitsInOrder(<ImagePickerState>[
            ImagePickerInitialState(),
            ImagePickerLoadingState(),
            ImagePickerLoadedState(images),
            ImagePickerQualityState(100),
            ImagePickerErrorState(ApplicationConstants.blocTestError)
          ]));
    });
  });

  group('ImagePickerBloc events and states mnitoring', () {
    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [] when nothing is added',
      build: () => ImagePickerBloc(),
      expect: () => const [],
    );

    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [ImagePickerLoadingState] when ImagePicker button pressed',
      build: () => ImagePickerBloc(),
      act: (bloc) => bloc.add(ImagePickerLoadingEvent()),
      expect: () => <ImagePickerState>[ImagePickerLoadingState()],
    );

    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [ImagePickerLoadedState] when Image was selected from gallery or camera',
      build: () => ImagePickerBloc(),
      act: (bloc) => bloc.add(ImagePickerSelectEvent(images: images)),
      expect: () => <ImagePickerState>[ImagePickerLoadingState(), ImagePickerLoadedState(images)],
    );

    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [ImagePickerInitialState] when reset button was pressed',
      build: () => ImagePickerBloc(),
      act: (bloc) => bloc.add(ImagePickerResetEvent()),
      expect: () => <ImagePickerState>[ImagePickerInitialState()],
    );

    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [ImagePickerInitialState] when reset button was pressed',
      build: () => ImagePickerBloc(),
      act: (bloc) => bloc.add(ImagePickerResetEvent()),
      expect: () => <ImagePickerState>[ImagePickerInitialState()],
    );

    blocTest<ImagePickerBloc, ImagePickerState>(
      'emits [ImagePickerInitialState] when reset button was pressed',
      build: () => ImagePickerBloc(),
      act: (bloc) => bloc.add(const ImagePickerSetQualityEvent(50)),
      expect: () => <ImagePickerState>[ImagePickerQualityState(50)],
    );
  });
}
