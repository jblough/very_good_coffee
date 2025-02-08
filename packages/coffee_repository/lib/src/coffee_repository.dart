import 'dart:math';

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
  final _imageStream = BehaviorSubject<String?>.seeded(null);

  Stream<CoffeeApiResponse> get coffeeApiResponse => _responseStream;

  Stream<String?> get currentImage => _imageStream;

  // Get a list of favorite coffee images
  Stream<List<String>> get favorites => _favoritesStream;

  static const _favoritesDirectory = 'favorites';

  void initialize() {
    loadFavorites();
    refreshImage();
  }

  // Get a random coffee image
  Future<void> refreshImage() async {
    final response = await _api.getRandomImageUrl();
    _responseStream.add(response);
    if (response.url != null) {
      _imageStream.add(response.url);
    }
  }

  Future<void> loadFavorites() async {
    final favorites = await _localStorage.loadFileList();
    _favoritesStream.add(favorites);

    // If an image has not been download yet, set the current image
    if (_imageStream.valueOrNull == null && favorites.isNotEmpty) {
      _imageStream.add(favorites[Random().nextInt(favorites.length)]);
    }
  }

  void setCurrentImage(String url) {
    _imageStream.add(url);
  }

  // Mark a coffee image as a favorite
  Future<void> addFavorite(String url) async {
    // Check that the file url/path isn't already a favorite
    final filename = url.split('/').last.toLowerCase();
    final isFavorite =
        _favoritesStream.value.any((e) => e.toLowerCase().endsWith(filename));
    if (!isFavorite) {
      final currentFavorites = _favoritesStream.value;
      final localPath = await _localStorage.downloadFile(url.convertToUrl());
      if (localPath != null) {
        currentFavorites.add(localPath);
        _favoritesStream.add(currentFavorites);
        // Update the current image stream to be the local file
        _imageStream.add(localPath);
      }
    }
  }

  // Remove a coffee image from the list of favorites
  Future<void> removeFavorite(String url) async {
    // Extract the filename from the URL to account for the file being
    // a URL or a local file
    final filename = url.split('/').last;
    final filteredList = _favoritesStream.value
        .where((element) => !element.endsWith(filename))
        .toList();
    _favoritesStream.add(filteredList);

    // Remove the favorite from the file system so it doesn't come back
    // the next the the app is launched
    await _localStorage.removeFile(url);
  }
}

extension on String {
  bool isLocalPath() => !toLowerCase().startsWith('http');

  /// Convert any local file paths to the original internet location
  String convertToUrl() {
    if (isLocalPath()) {
      final filename = split('/').last;
      return '$coffeeApiRoot/$filename';
    } else {
      return this;
    }
  }
}
