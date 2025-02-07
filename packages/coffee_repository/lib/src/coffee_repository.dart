import 'package:coffee_api/coffee_api.dart';
import 'package:local_storage/local_storage.dart';
import 'package:rxdart/rxdart.dart';

class CoffeeRepository {
  CoffeeRepository({CoffeeApiClient? api, LocalStorage? localStorage})
      : _api = api ?? CoffeeApiClient(),
        _localStorage = localStorage ?? LocalStorage();

  final CoffeeApiClient _api;
  final LocalStorage _localStorage;

  final _imageUrlStream = BehaviorSubject<String?>();
  final _favoritesStream = BehaviorSubject<List<String>>.seeded([]);

  Stream<String?> get coffeeImage => _imageUrlStream;

  static const _favoritesDirectory = 'favorites';

  // Get a random coffee image
  Future<void> refreshImage() async {
    final url = await _api.getRandomImageUrl();
    if (url != null) {
      _imageUrlStream.add(url);
    }
  }

  // Save a coffee image locally
  Future<String?> saveLocally(String url) async {
    return _localStorage.downloadFile(url, subdirectory: _favoritesDirectory);
  }

  Future<void> loadFavorites() async {
    final favorites = await _localStorage.loadFileList(_favoritesDirectory);
    _favoritesStream.add(favorites);
  }

  bool isFavorite(String url) {
    final filename = url.split('/').last;
    return _favoritesStream.value.any((element) => element.endsWith(filename));
  }

  // Mark a coffee image as a favorite
  Future<void> addFavorite(String url) async {
    // Check that the file url/path isn't already a favorite
    if (!isFavorite(url)) {
      final currentFavorites = _favoritesStream.value;
      final localPath = await _localStorage.downloadFile(
        url,
        subdirectory: _favoritesDirectory,
      );
      if (localPath != null) {
        currentFavorites.add(localPath);
        _favoritesStream.add(currentFavorites);
      }
    }
  }

  // Remove a coffee image from the list of favorites
  void removeFavorite(String url) {
    // Extract the filename from the URL to account for the file being
    // a URL or a local file
    final filename = url.split('/').last;
    final filteredList = _favoritesStream.value
        .where((element) => !element.endsWith(filename))
        .toList();
    _favoritesStream.add(filteredList);

    // Remove the favorite from the file system so it doesn't come back
    // the next the the app is launched
    _localStorage.removeFile(url);
  }

  // Get a list of favorite coffee images
  Stream<List<String>> favorites() => _favoritesStream;
}
