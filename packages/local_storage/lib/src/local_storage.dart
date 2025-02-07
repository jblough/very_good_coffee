import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  LocalStorage({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // TODO(me): Look at using exceptions for better error handling

  Future<String?> downloadFile(String url, {String? subdirectory}) async {
    final filename = url.split('/').last;
    final directory = await getApplicationCacheDirectory();
    final destinationPath = (subdirectory != null)
        ? '${directory.path}/$subdirectory/$filename'
        : '${directory.path}/$filename';
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

  Future<List<String>> loadFileList(String subdirectory) async {
    final path = (await getApplicationCacheDirectory()).path;
    final directory = Directory('$path/$subdirectory');
    if (directory.existsSync()) {
      return directory.listSync().map((file) => file.path).toList();
    }
    return [];
  }

  Future<void> removeFile(String url) async {
    final path = await getApplicationCacheDirectory();
    // Make sure we're only deleting from the expected directory
    if (url.startsWith(path.path)) {
      final file = File(url);
      await file.delete();
    }
  }
}
