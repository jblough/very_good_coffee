import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_button/bloc/favorites_button_state.dart';
import 'package:very_good_coffee/favorites_button/favorites_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesButtonCubit = MockFavoritesButtonCubit();

  setUp(() {
    reset(favoritesButtonCubit);

    // Default values
    when(() => favoritesButtonCubit.state)
        .thenReturn(const FavoritesButtonState());
    when(() => favoritesButtonCubit.stream)
        .thenAnswer((_) => Stream.value(const FavoritesButtonState()));
    when(() => favoritesButtonCubit.isFavorite(any())).thenReturn(false);
    when(favoritesButtonCubit.close).thenAnswer((_) async {});
  });

  group('FavoritesButton tests', () {
    testWidgets(
        'should see correct favorite icon and label when not a favorite',
        (tester) async {
      const url = 'b.png';
      const state = FavoritesButtonState(favorites: ['a.png']);
      when(() => favoritesButtonCubit.state).thenReturn(state);
      when(() => favoritesButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonCubit.isFavorite(any())).thenReturn(false);

      final widget = addProviders(
        const FavoriteButton(url: url),
        favoritesButtonCubit: favoritesButtonCubit,
      );
      await tester.pumpApp(widget);
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Add this image to your list of favorite images');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite_outline);
      verify(() => favoritesButtonCubit.isFavorite(url));
    });

    testWidgets('should see correct favorite icon and label when a favorite',
        (tester) async {
      const url = 'a.png';
      const state = FavoritesButtonState(favorites: ['a.png']);
      when(() => favoritesButtonCubit.state).thenReturn(state);
      when(() => favoritesButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonCubit.isFavorite(any())).thenReturn(true);

      final widget = addProviders(
        const FavoriteButton(url: url),
        favoritesButtonCubit: favoritesButtonCubit,
      );
      await tester.pumpApp(widget);
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Remove this image from your list of favorites');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite);
      verify(() => favoritesButtonCubit.isFavorite(url));
    });
  });
}
