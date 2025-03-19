import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Error thrown when a file download fails.
class FileDownloadException implements Exception {}

/// Error thrown when a downloaded file failed to be saved locally.
class FileSaveException implements Exception {}

/// Error thrown when a local file was unable to be deleted.
class FileDeleteException implements Exception {}

/// Error thrown when the given path is not in the correct location.
class InvalidPathException implements Exception {}

class LocalStorage {
  LocalStorage({
    required this.subdirectory,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String subdirectory;

  /// Download the file at [url] and save locally
  ///
  /// If the file failed to download, a FileDownloadException is thrown
  /// If the file is downloaded but fails to save locally, then a.
  ///   FileSaveException is thrown.
  Future<String> downloadFile(String url) async {
    final filename = url.split('/').last;
    final directory = await getApplicationCacheDirectory();
    final destinationPath = '${directory.path}/$subdirectory/$filename';
    var destination = File.fromUri(Uri.parse(destinationPath));
    final data = await _downloadFile(url);
    try {
      destination = await destination.create(recursive: true);
      destination = await destination.writeAsBytes(data);
      return destinationPath;
    } catch (e) {
      throw FileSaveException();
    }
  }

  Future<Uint8List> _downloadFile(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw FileDownloadException();
      }
    } catch (e) {
      throw FileDownloadException();
    }
  }

  /// Load a list of all the files in the subdirectory.
  Future<List<String>> loadFileList() async {
    final path = (await getApplicationCacheDirectory()).path;
    final directory = Directory('$path/$subdirectory');
    if (directory.existsSync()) {
      return directory.listSync().map((file) => file.path).toList();
    }
    return [];
  }

  /// Remove the file from local storage provided its [url].
  ///
  /// If the url is not in the correct local location, then a
  ///   InvalidPathException is thrown.
  /// If the file is unable to be deleted a FileDeleteException is thrown.
  Future<void> removeFile(String url) async {
    final path = await getApplicationCacheDirectory();
    final acceptablePath = '${path.path}/$subdirectory';
    // Make sure we're only deleting from the expected directory
    if (url.startsWith(acceptablePath)) {
      try {
        final file = File(url);
        await file.delete();
      } catch (e) {
        throw FileDeleteException();
      }
    } else {
      throw InvalidPathException();
    }
  }
}
