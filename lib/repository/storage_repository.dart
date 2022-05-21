import 'dart:io';

import '../service/storage_service.dart';

abstract class IStorageRepository {
  Future<String> get localPath;
  Future<File> getLocalFile(String fileName);
  Future<String> readData(String fileName);
  Future<File> writeData(String data, String fileName);
  Future<List<File>> getLocalFileList();
  Future<int> deleteFile(File file);
}

class StorageRepository extends IStorageRepository {
  final IStorageService _storageService;

  StorageRepository(this._storageService);

  @override
  Future<int> deleteFile(File file) async {
    return await _storageService.deleteFile(file);
  }

  @override
  Future<File> getLocalFile(String fileName) async {
    return await _storageService.getLocalFile(fileName);
  }

  @override
  Future<List<File>> getLocalFileList() async {
    // await Future.delayed(const Duration(milliseconds: 1));
    return await Future.value(_storageService.getLocalFileList());
  }

  @override
  Future<String> get localPath => _storageService.localPath;

  @override
  Future<String> readData(String fileName) async {
    return await _storageService.readData(fileName);
  }

  @override
  Future<File> writeData(String data, String fileName) {
    return _storageService.writeData(data, fileName);
  }
}
