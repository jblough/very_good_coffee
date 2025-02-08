import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';

void main() {
  group('FavoriteButtonState tests', () {
    test('should return true for is favorite', () async {
      const url = 'a.png';
      const favorites = [url];

      const state = FavoriteButtonState(
        currentImage: url,
        favorites: favorites,
      );

      expect(state.isFavorite(), isTrue);
    });

    test('should return false for is favorite', () async {
      const url = 'a.png';
      const favorites = ['b.png'];

      const state = FavoriteButtonState(
        currentImage: url,
        favorites: favorites,
      );

      expect(state.isFavorite(), isFalse);
    });
  });
}
