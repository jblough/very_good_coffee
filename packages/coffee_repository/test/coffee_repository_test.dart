import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:local_storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements CoffeeApiClient {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  final client = MockApiClient();
  final storage = MockLocalStorage();

  setUp(() {
    reset(client);
    reset(storage);
  });

  group('CoffeeRepository tests', () {
    group('initialization tests', () {
      test('should initialize with real dependencies', () {
        final repository = CoffeeRepository();
        expect(repository, isNotNull);
      });

      test('should initialize', () async {
        when(storage.loadFileList).thenAnswer((_) async => []);
        when(client.getRandomImageUrl).thenAnswer(
          (_) async => CoffeeApiResponse.empty(),
        );

        final repository = CoffeeRepository(api: client, localStorage: storage);
        await repository.initialize();

        verify(client.getRandomImageUrl).called(1);
        verify(storage.loadFileList).called(1);
      });
    });

    group('refresh image tests', () {
      test('should refresh image', () async {
        const imageUrl = 'https://test.com/test.png';
        when(client.getRandomImageUrl)
            .thenAnswer((_) async => CoffeeApiResponse.ok(imageUrl));

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.coffeeApiResponse, emits(CoffeeApiResponse.empty()));
        expect(repository.currentImage, emits(null));

        await repository.refreshImage();

        // Check updated state
        expect(
          repository.coffeeApiResponse,
          emits(CoffeeApiResponse.ok(imageUrl)),
        );
        expect(repository.currentImage, emits(imageUrl));
      });
    });

    group('load favorites tests', () {
      test('should load favorites', () async {
        final favorites = ['a.png'];
        when(storage.loadFileList).thenAnswer((_) async => favorites);

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));
        expect(repository.currentImage, emits(null));

        await repository.loadFavorites();

        expect(repository.favorites, emits(favorites));
        expect(repository.currentImage, emits(favorites[0]));
      });

      test('should load empty favorites', () async {
        when(storage.loadFileList).thenAnswer((_) async => []);

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));
        expect(repository.currentImage, emits(null));

        await repository.loadFavorites();

        expect(repository.favorites, emits([]));
        expect(repository.currentImage, emits(null));
      });
    });

    group('set current image tests', () {
      test('should set current image', () async {
        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.currentImage, emits(null));

        const url = 'a.png';
        repository.setCurrentImage(url);

        expect(repository.currentImage, emits(url));
      });
    });

    group('add favorite tests', () {
      test('should add favorite', () async {
        const url = 'https://test.com/a.png';
        const localUrl = 'cache/subdir/a.png';
        final favorites = ['cache/subdir/b.png'];
        when(storage.loadFileList).thenAnswer((_) async => favorites);
        when(() => storage.downloadFile(url)).thenAnswer((_) async => localUrl);

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));

        await repository.loadFavorites();
        expect(repository.favorites, emits(favorites));

        await repository.addFavorite(url);

        // Check updated state
        expect(repository.favorites, emits(['cache/subdir/b.png', localUrl]));

        verify(() => storage.downloadFile(url));
      });

      test('should add local file as favorite', () async {
        const localUrl = 'cache/subdir/a.png';
        final favorites = ['cache/subdir/b.png'];
        when(storage.loadFileList).thenAnswer((_) async => favorites);
        when(() => storage.downloadFile(any()))
            .thenAnswer((_) async => localUrl);

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));

        await repository.loadFavorites();
        expect(repository.favorites, emits(favorites));

        await repository.addFavorite(localUrl);

        // Check updated state
        expect(repository.favorites, emits(['cache/subdir/b.png', localUrl]));

        verify(
          () => storage.downloadFile('https://coffee.alexflipnote.dev/a.png'),
        );
      });

      test('should not add favorite when download fails', () async {
        const localUrl = 'cache/subdir/a.png';
        final favorites = ['cache/subdir/b.png'];
        when(storage.loadFileList).thenAnswer((_) async => favorites);
        when(() => storage.downloadFile(any())).thenThrow(FileSaveException());

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));

        await repository.loadFavorites();
        expect(repository.favorites, emits(favorites));

        await repository.addFavorite(localUrl);

        // Check updated state
        expect(repository.favorites, emits(favorites));

        verify(
          () => storage.downloadFile('https://coffee.alexflipnote.dev/a.png'),
        );
      });
    });

    group('remove favorite tests', () {
      test('should remove favorite', () async {
        const localUrl = 'cache/subdir/a.png';
        final favorites = ['cache/subdir/b.png', 'cache/subdir/a.png'];
        when(storage.loadFileList).thenAnswer((_) async => favorites);
        when(() => storage.removeFile(localUrl)).thenAnswer((_) async {});

        final repository = CoffeeRepository(api: client, localStorage: storage);

        // Check initial state
        expect(repository.favorites, emits([]));

        await repository.loadFavorites();
        expect(repository.favorites, emits(favorites));

        await repository.removeFavorite(localUrl);

        // Check updated state
        expect(repository.favorites, emits(['cache/subdir/b.png']));

        verify(() => storage.removeFile(localUrl));
      });
    });
  });
}
