import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class IStorageService {
  Future<String> get localPath;
  Future<File> getLocalFile(String fileName);
  Future<String> readData(String fileName);
  Future<File> writeData(String data, String fileName);
  Future<List<File>> getLocalFileList();
  Future<int> deleteFile(File file);
}

class StorageService extends IStorageService {
  @override
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<File> getLocalFile(String fileName) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  @override
  Future<String> readData(String fileName) async {
    try {
      final file = await getLocalFile(fileName);
      String body = file.readAsStringSync();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<File> writeData(String data, String fileName) async {
    final File file = await getLocalFile(fileName);
    return file.writeAsString(data);
  }

  @override
  Future<List<File>> getLocalFileList() async {
    final directory = await getApplicationDocumentsDirectory();

    List<FileSystemEntity> localFileList = Directory(directory.path).listSync();

    // Future.delayed(const Duration(milliseconds: 1));
    List<File> collagePdfList;
    collagePdfList = localFileList.whereType<File>().toList();

    collagePdfList.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return await Future.value(collagePdfList);
  }

  @override
  Future<int> deleteFile(File file) async {
    try {
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
