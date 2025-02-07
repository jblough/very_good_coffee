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

    when(pathProvider.getApplicationCachePath)
        .thenAnswer((_) async => 'fake-path');
    when(() => directory.path).thenReturn('fake-directory');
  });

  group('download file tests', () {
    test('should successfully download and store file locally', () async {
      final response = http.Response('image-content', 200);
      when(() => client.get(Uri.parse('https://test.com/test.png')))
          .thenAnswer((_) async => response);

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

    test('should error when failing to download file', () async {
      final response = http.Response('', 400);
      when(() => client.get(Uri.parse('https://test.com/test.png')))
          .thenAnswer((_) async => response);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final local = await storage.downloadFile('https://test.com/test.png');

          // Check that the file was downloaded
          verify(() => client.get(Uri.parse('https://test.com/test.png')));

          // Check that no attempt was made to create the file
          verifyNever(() => file.create(recursive: any(named: 'recursive')));

          // Check that no attempt was made to write a file
          verifyNever(() => file.writeAsBytes(any()));

          expect(local, isNull);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });

    test('should error when unable to create the local file', () async {
      final response = http.Response('image-content', 200);
      when(() => client.get(Uri.parse('https://test.com/test.png')))
          .thenAnswer((_) async => response);

      when(() => file.create(recursive: true))
          .thenThrow(Exception('Unable to create file'));

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final local = await storage.downloadFile('https://test.com/test.png');

          // Check that the file was downloaded
          verify(() => client.get(Uri.parse('https://test.com/test.png')));

          // Check that no attempt was made to create the file
          verify(() => file.create(recursive: true));

          // Check that no attempt was made to write a file
          verifyNever(() => file.writeAsBytes(any()));

          expect(local, isNull);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });

    test('should error when unable to write the local file', () async {
      final response = http.Response('image-content', 200);
      when(() => client.get(Uri.parse('https://test.com/test.png')))
          .thenAnswer((_) async => response);

      when(() => file.create(recursive: true)).thenAnswer((_) async => file);
      when(() => file.writeAsBytes(any()))
          .thenThrow(Exception('Unable to write file'));

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final local = await storage.downloadFile('https://test.com/test.png');

          // Check that the file was downloaded
          verify(() => client.get(Uri.parse('https://test.com/test.png')));

          // Check that no attempt was made to create the file
          verify(() => file.create(recursive: true));

          // Check that no attempt was made to write a file
          verify(() => file.writeAsBytes('image-content'.codeUnits));

          expect(local, isNull);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });
  });

  group('load file list tests', () {
    test('should load list of files in directory', () async {
      final files = [File('a'), File('b')];
      when(directory.existsSync).thenAnswer((_) => true);
      when(directory.listSync).thenAnswer((_) => files);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final fileList = await storage.loadFileList('subdir');

          expect(fileList, ['a', 'b']);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });

    test('should return empty list of files for no directory', () async {
      when(directory.existsSync).thenAnswer((_) => false);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final fileList = await storage.loadFileList('subdir');

          verifyNever(directory.listSync);

          expect(fileList, <FileSystemEntity>[]);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });

    test('should load list of files in directory', () async {
      final files = <FileSystemEntity>[];
      when(directory.existsSync).thenAnswer((_) => true);
      when(directory.listSync).thenAnswer((_) => files);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          final fileList = await storage.loadFileList('subdir');

          expect(fileList, <String>[]);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });
  });

  group('delete file tests', () {
    test('should delete file', () async {
      when(file.delete).thenAnswer((_) async => file);

      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          await storage.removeFile('fake-directory/test-file');

          verify(file.delete);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });

    test('should not delete file in wrong directory', () async {
      await IOOverrides.runZoned(
        () async {
          final storage = LocalStorage(client: client);
          await storage.removeFile('different-fake-directory/test-file');

          verifyNever(file.delete);
        },
        createDirectory: (String path) => directory,
        createFile: (String path) => file,
      );
    });
  });
}
