import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:local_storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final client = MockHttpClient();
  final pathProvider = MockPathProviderPlatform();
  final directory = MockDirectory();
  final file = MockFile();

  setUpAll(() {
    PathProviderPlatform.instance = pathProvider;
  });

  setUp(() {
    reset(client);
    reset(pathProvider);
    reset(directory);
  });

  group('download file tests', () {
    /*
    Scenarios to test
      - success
      - error downloading file
      - error creating file
      - error writing file
     */
    test('should successfully download and store file locally', () async {
      final response = http.Response('image-content', 200);
      when(() => client.get(Uri.parse('https://test.com/test.png')))
          .thenAnswer((_) async => response);

      when(pathProvider.getApplicationCachePath)
          .thenAnswer((_) async => 'fake-path');
      when(() => directory.path).thenReturn('fake-directory');
      when(() => file.create(recursive: true)).thenAnswer((_) async => file);
      when(() => file.writeAsBytes(any())).thenAnswer((_) async => file);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final local = await storage.downloadFile('https://test.com/test.png');

          // Check that the file was downloaded
          verify(() => client.get(Uri.parse('https://test.com/test.png')));

          // Check that the file was created
          verify(() => file.create(recursive: true));

          // Check that the correct data what written to the file
          verify(() => file.writeAsBytes('image-content'.codeUnits));

          expect(local, 'fake-directory/test.png');
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });
  });

  group('load file list tests', () {
    /*
    Scenarios to test
      - success (directory exists and has files in it)
      - directory does not exist
      - directory is empty
     */
  });

  group('delete file tests', () {
    /*
    Scenarios to test
      - success
      - error deleting file
      - file is not in the expected directory (should not attempt to delete)
     */
  });
}
