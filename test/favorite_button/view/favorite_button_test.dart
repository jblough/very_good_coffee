import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesButtonCubit = MockFavoriteButtonCubit();

  setUp(() {
    reset(favoritesButtonCubit);

    // Default values
    when(() => favoritesButtonCubit.state)
        .thenReturn(const FavoriteButtonState());
    when(() => favoritesButtonCubit.stream)
        .thenAnswer((_) => Stream.value(const FavoriteButtonState()));
    when(favoritesButtonCubit.close).thenAnswer((_) async {});
  });

  Widget generateWidget(String url) => addProviders(
        FavoriteButton(url: url),
        favoriteButtonCubit: favoritesButtonCubit,
      );

  group('FavoritesButton tests', () {
    testWidgets(
        'should see correct favorite icon and label when not a favorite',
        (tester) async {
      const url = 'b.png';
      const state = FavoriteButtonState(favorites: ['a.png']);
      when(() => favoritesButtonCubit.state).thenReturn(state);
      when(() => favoritesButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonCubit.addFavorite(any()))
          .thenAnswer((_) async {});

      final widget = generateWidget(url);
      await tester.pumpApp(widget);
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Add this image to your list of favorite images');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite_outline);

      // Tap on the button to add to favorites
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      verify(() => favoritesButtonCubit.addFavorite(url));
    });

    testWidgets('should see correct favorite icon and label when a favorite',
        (tester) async {
      const url = 'a.png';
      const state = FavoriteButtonState(
        currentImage: url,
        favorites: ['a.png'],
      );
      when(() => favoritesButtonCubit.state).thenReturn(state);
      when(() => favoritesButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonCubit.removeFavorite(any()))
          .thenAnswer((_) async {});

      final widget = generateWidget(url);
      await tester.pumpApp(widget);
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Remove this image from your list of favorites');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite);

      // Tap on the button to remove from favorites
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      verify(() => favoritesButtonCubit.removeFavorite(url));
    });
  });
}
