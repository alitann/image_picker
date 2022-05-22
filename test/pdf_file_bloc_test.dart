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

class MockPdfService extends Mock implements PdfService {}

class MockBuildContext extends Mock implements BuildContext {}

class NewPdfService implements IPdfService {
  @override
  Future<File?> createPdfFile(BuildContext contextMain, List<CImage> selectedImages) async {
    File file = File('path');
    await Future.delayed(const Duration(milliseconds: 100));
    return file;
  }

  @override
  void showPdf(File file) {}
}

void main() {
  final File file = File('path');
  List<CImage> imageList = [CollageImage(path: 'path')];
  late MockBuildContext mockContext;
  late MockPdfService mockPdfService;
  late PdfRepository mockPdfRepository;

  setUpAll(() {
    mockContext = MockBuildContext();
    mockPdfService = MockPdfService();
    mockPdfRepository = PdfRepository(mockPdfService);
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

  group('Create Pdf File', () {
    test('Create Pdf File from the Pdf Service', () async {
      when(() => mockPdfService.createPdfFile(mockContext, imageList)).thenAnswer((invocation) async => file);
      await mockPdfRepository.createPdfFile(mockContext, imageList);
      verify(() => mockPdfService.createPdfFile(mockContext, imageList)).called(1);
    });
  });

  group('PdfFileBloc --> PdfFileEvent and PdfFileState moitoring  ', () {
    blocTest<PdfFileBloc, PdfFileState>(
      'emits [] when nothing is added',
      build: () => PdfFileBloc(mockPdfRepository),
      expect: () => const [],
    );

    blocTest<PdfFileBloc, PdfFileState>(
      'emits [PdfFileLoading,PdfFileCreated] when PdfFileCreateRequest button pressed',
      build: () => PdfFileBloc(mockPdfRepository),
      act: ((bloc) {
        when(() => mockPdfService.createPdfFile(mockContext, imageList)).thenAnswer((invocation) async => file);
        bloc.add(PdfFileCreateRequest(imageList, mockContext));
      }),
      expect: () => <PdfFileState>[PdfFileLoading(), PdfFileCreated(file)],
    );

    blocTest<PdfFileBloc, PdfFileState>(
      'emits [PdfFileInitial] when PdfFileResetRequest button pressed',
      build: () => PdfFileBloc(mockPdfRepository),
      act: (bloc) => bloc.add(PdfFileResetRequest()),
      expect: () => <PdfFileState>[PdfFileInitial()],
    );

    blocTest<PdfFileBloc, PdfFileState>(
      'emits [PdfFileLoading,PdfFileError] when PdfFileCreateRequest button pressed',
      build: () => PdfFileBloc(mockPdfRepository),
      act: ((bloc) {
        when(() => mockPdfService.createPdfFile(mockContext, imageList)).thenThrow((invocation) async => file);
        bloc.add(PdfFileCreateRequest(imageList, mockContext));
      }),
      expect: () => <PdfFileState>[PdfFileLoading(), const PdfFileError(ApplicationConstants.blocTestError)],
    );

    blocTest<PdfFileBloc, PdfFileState>(
      'emits [PdfFileLoading,PdfFileError with 0 image] when PdfFileCreateRequest button pressed',
      build: () => PdfFileBloc(mockPdfRepository),
      act: ((bloc) {
        when(() => mockPdfService.createPdfFile(mockContext, imageList)).thenThrow((invocation) async => []);
        bloc.add(PdfFileCreateRequest(imageList, mockContext));
      }),
      expect: () => <PdfFileState>[PdfFileLoading(), const PdfFileError(ApplicationConstants.minImageError)],
    );
  });
}
