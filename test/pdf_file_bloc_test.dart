import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_collage/bloc/bloc/pdf_file_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';
import 'package:image_collage/model/collage_image.dart';
import 'package:image_collage/repository/pdf_repository.dart';
import 'package:image_collage/service/pdf_service.dart';
import 'package:mocktail/mocktail.dart';

class MockPdfFileBloc extends MockBloc<PdfFileEvent, PdfFileState> implements PdfFileBloc {}

class MockPdfRepository extends Mock implements IPdfRepository {}

class MockPdfService extends Mock implements IPdfService {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  final Future<File> file = Future.value(File('path'));
  // final File file2 = File('path');
  List<CImage> imageList = [CollageImage(path: 'path')];

  // final MockPdfService mockPdfService = MockPdfService();

  late MockPdfRepository mockPdfRepository;
  late MockBuildContext mockContext;

  setUpAll(() {
    mockPdfRepository = MockPdfRepository();
    mockContext = MockBuildContext();
  });

  group('MockPdfFileBloc Listen', () {
    test("Mock the MockImagePickerBloc's stream!", () {
      final bloc = MockPdfFileBloc();
      whenListen(
          bloc,
          Stream.fromIterable([
            PdfFileInitial(),
            PdfFileLoading(),
            PdfFileCreated(file),
            const PdfFileError(ApplicationConstants.blocTestError)
          ]));
      expectLater(
          bloc.stream,
          emitsInOrder(<PdfFileState>[
            PdfFileInitial(),
            PdfFileLoading(),
            PdfFileCreated(file),
            const PdfFileError(ApplicationConstants.blocTestError)
          ]));
    });
  });

  // test('test name', () async {
  //   when(() => mockPdfService.createPdfFile(mockContext, imageList).then((value) => value = file2));
  //   // final result = await mockPdfRepository.createPdfFile(mockContext, imageList);
  //   // expect(result, file2);
  // });

  blocTest<PdfFileBloc, PdfFileState>(
    'emits [] when nothing is added',
    build: () => PdfFileBloc(mockPdfRepository),
    expect: () => const [],
  );

  blocTest<PdfFileBloc, PdfFileState>(
    'emits [PdfFileLoading,PdfFileError] when PdfFileCreateRequest button pressed',
    build: () => PdfFileBloc(mockPdfRepository),
    act: (bloc) => bloc.add(PdfFileCreateRequest(imageList, mockContext)),
    expect: () => <PdfFileState>[PdfFileLoading(), const PdfFileError(ApplicationConstants.blocTestError)],
  );

  blocTest<PdfFileBloc, PdfFileState>(
    'emits [PdfFileInitial] when PdfFileResetRequest button pressed',
    build: () => PdfFileBloc(mockPdfRepository),
    act: (bloc) => bloc.add(PdfFileResetRequest()),
    expect: () => <PdfFileState>[PdfFileInitial()],
  );
}
