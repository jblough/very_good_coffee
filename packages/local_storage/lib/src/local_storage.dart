import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  LocalStorage({
    required this.subdirectory,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String subdirectory;

  // TODO(me): Look at using exceptions for better error handling

  /// Download a file from the internet and save locally
  Future<String?> downloadFile(String url) async {
    final filename = url.split('/').last;
    final directory = await getApplicationCacheDirectory();
    final destinationPath = '${directory.path}/$subdirectory/$filename';
    var destination = File.fromUri(Uri.parse(destinationPath));
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        destination = await destination.create(recursive: true);
        destination = await destination.writeAsBytes(response.bodyBytes);
        return destinationPath;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Load a list of all the files in the subdirectory
  Future<List<String>> loadFileList() async {
    final path = (await getApplicationCacheDirectory()).path;
    final directory = Directory('$path/$subdirectory');
    if (directory.existsSync()) {
      return directory.listSync().map((file) => file.path).toList();
    }
    return [];
  }

  /// Remove the file from local storage
  Future<void> removeFile(String url) async {
    final path = await getApplicationCacheDirectory();
    final acceptablePath = '${path.path}/$subdirectory';
    // Make sure we're only deleting from the expected directory
    if (url.startsWith(acceptablePath)) {
      final file = File(url);
      await file.delete();
    }
  }
}
