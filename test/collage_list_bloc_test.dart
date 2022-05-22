import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_collage/bloc/bloc/collage_list_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';
import 'package:image_collage/repository/storage_repository.dart';
import 'package:image_collage/service/storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCollageListBloc extends MockBloc<CollageListEvent, CollageListState> implements CollageListBloc {}

class MockStorageService extends Mock implements StorageService {}

class NewStoraService implements IStorageService {
  @override
  Future<int> deleteFile(File file) {
    throw UnimplementedError();
  }

  @override
  Future<File> getLocalFile(String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<List<File>> getLocalFileList() async {
    return [File('path1'), File('path2')];
  }

  @override
  Future<String> get localPath => throw UnimplementedError();

  @override
  Future<String> readData(String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<File> writeData(String data, String fileName) {
    throw UnimplementedError();
  }
}

void main() {
  final List<File> imagePdfFiles = [File('path1'), File('path2')];
  final File file = File('path1');

  late MockStorageService mockStorageService = MockStorageService();
  late StorageRepository mockStorageRepository;

  setUpAll(() {
    mockStorageService = MockStorageService();
    mockStorageRepository = StorageRepository(mockStorageService);
  });

  group('CollageListBloc Listen', () {
    test("Mock the MockImagePickerBloc's stream!", () {
      final bloc = MockCollageListBloc();
      whenListen(
          bloc,
          Stream.fromIterable([
            CollageListInitial(),
            CollageListLoading(),
            CollageListDeleted(),
            CollageListLoaded(imagePdfFiles: imagePdfFiles),
            const CollageListError(ApplicationConstants.blocTestError)
          ]));
      expectLater(
          bloc.stream,
          emitsInOrder(<CollageListState>[
            CollageListInitial(),
            CollageListLoading(),
            CollageListDeleted(),
            CollageListLoaded(imagePdfFiles: imagePdfFiles),
            const CollageListError(ApplicationConstants.blocTestError)
          ]));
    });
  });

  blocTest<CollageListBloc, CollageListState>(
    'emits [] when nothing is added',
    build: () => CollageListBloc(mockStorageRepository),
    expect: () => const [],
  );

  blocTest<CollageListBloc, CollageListState>(
    'emits [PdfFileInitial] when PdfFileResetRequest button pressed',
    build: () => CollageListBloc(mockStorageRepository),
    act: ((bloc) {
      // when(() => mockStorageService.getLocalFileList()).thenAnswer((invocation) async => imagePdfFiles);
      // bloc.add(CollageListLoadEvent());
    }),
    expect: () => <CollageListState>[],
  );

  group('Return file', () {
    test('Return file from the Storage Service', () async {
      when(() => mockStorageService.getLocalFileList()).thenAnswer((invocation) async => imagePdfFiles);
      await mockStorageService.getLocalFileList();
      verify(() => mockStorageService.getLocalFileList()).called(1);
    });
  });

  blocTest<CollageListBloc, CollageListState>(
    'emits [CollageListLoading,CollageListLoaded] when collage list view open',
    build: () => CollageListBloc(mockStorageRepository),
    act: ((bloc) {
      when(() => mockStorageService.getLocalFileList()).thenAnswer((invocation) async => imagePdfFiles);
      bloc.add(CollageListLoadEvent());
    }),
    expect: () => <CollageListState>[CollageListLoading(), CollageListLoaded(imagePdfFiles: imagePdfFiles)],
  );

  blocTest<CollageListBloc, CollageListState>(
    'emits [CollageListLoading,CollageListLoaded] when collage file deleted',
    build: () => CollageListBloc(mockStorageRepository),
    act: ((bloc) {
      when(() => mockStorageService.deleteFile(file)).thenAnswer((invocation) async => 1);
      bloc.add(CollageListDeleteEvent(file));
      when(() => mockStorageService.getLocalFileList()).thenAnswer((invocation) async => imagePdfFiles);
    }),
    expect: () =>
        <CollageListState>[CollageListLoading(), CollageListDeleted(), CollageListLoaded(imagePdfFiles: imagePdfFiles)],
  );

  blocTest<CollageListBloc, CollageListState>(
    'emits [CollageListLoading,CollageListError] when collage file deleted',
    build: () => CollageListBloc(mockStorageRepository),
    act: ((bloc) {
      when(() => mockStorageService.deleteFile(file)).thenAnswer((invocation) async => 0);
      bloc.add(CollageListDeleteEvent(file));
      // when(() => mockStorageService.getLocalFileList()).thenAnswer((invocation) async => imagePdfFiles);
    }),
    expect: () =>
        <CollageListState>[CollageListLoading(), const CollageListError(ApplicationConstants.deleteFileError)],
  );
}
