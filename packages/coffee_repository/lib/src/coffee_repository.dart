import 'package:coffee_api/coffee_api.dart';
import 'package:local_storage/local_storage.dart';
import 'package:rxdart/rxdart.dart';

class CoffeeRepository {
  CoffeeRepository({CoffeeApiClient? api, LocalStorage? localStorage})
      : _api = api ?? CoffeeApiClient(),
        _localStorage =
            localStorage ?? LocalStorage(subdirectory: _favoritesDirectory);

  final CoffeeApiClient _api;
  final LocalStorage _localStorage;

  final _responseStream = BehaviorSubject<CoffeeApiResponse>.seeded(
    CoffeeApiResponse.error(CoffeeApiResponseStatus.empty),
  );
  final _favoritesStream = BehaviorSubject<List<String>>.seeded([]);
  final _imageStream = BehaviorSubject<String?>();

  Stream<CoffeeApiResponse> get coffeeApiResponse => _responseStream;

  Stream<String?> get currentImage => _imageStream;

  static const _favoritesDirectory = 'favorites';

  // Get a random coffee image
  Future<void> refreshImage() async {
    final response = await _api.getRandomImageUrl();
    _responseStream.add(response);
    if (response.url != null) {
      _imageStream.add(response.url);
    }
  }

  // Save a coffee image locally
  Future<String?> saveLocally(String url) async {
    return _localStorage.downloadFile(url);
  }

  Future<void> loadFavorites() async {
    final favorites = await _localStorage.loadFileList();
    _favoritesStream.add(favorites);

    // If an image has not been download yet, set the current image
    if (_imageStream.valueOrNull == null && favorites.isNotEmpty) {
      // TODO(me): Pick a random image from the list
      _imageStream.add(favorites[0]);
    }
  }

  void setCurrentImage(String url) {
    _imageStream.add(url);
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
      final localPath = await _localStorage.downloadFile(url);
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

    // TODO(me): Think about if the current image should be changed
    //  since the file is being removed from the filesystem

    // Remove the favorite from the file system so it doesn't come back
    // the next the the app is launched
    _localStorage.removeFile(url);
  }

  // Get a list of favorite coffee images
  Stream<List<String>> get favorites => _favoritesStream;
}
