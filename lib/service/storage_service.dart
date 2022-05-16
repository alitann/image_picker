import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class AStorageService {
  Future<String> get localPath;
  Future<File> getLocalFile(String fileName);
  Future<String> readData(String fileName);
  Future<File> writeData(String data, String fileName);
  List<FileSystemEntity> getLocalFileList({String folderName});
}

class StorageService extends AStorageService {
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
  List<FileSystemEntity> getLocalFileList({String folderName = "pdf"}) {
    List<FileSystemEntity> localFileList = Directory('$localPath').listSync();
    return localFileList;
  }
}
