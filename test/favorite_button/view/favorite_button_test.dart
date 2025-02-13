import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesButtonBloc = MockFavoriteButtonBloc();

  setUpAll(() {
    registerFallbackValue(const IncomingFavorites([]));
  });
  setUp(() {
    reset(favoritesButtonBloc);

    // Default values
    when(() => favoritesButtonBloc.state)
        .thenReturn(const FavoriteButtonState());
    when(() => favoritesButtonBloc.stream)
        .thenAnswer((_) => Stream.value(const FavoriteButtonState()));
    when(favoritesButtonBloc.close).thenAnswer((_) async {});
  });

  Widget generateWidget(String url) => addProviders(
        FavoriteButton(url: url, bloc: favoritesButtonBloc),
      );

  group('FavoritesButton tests', () {
    testWidgets(
        'should see correct favorite icon and label when not a favorite',
        (tester) async {
      const url = 'b.png';
      const state = FavoriteButtonState(favorites: ['a.png']);
      when(() => favoritesButtonBloc.state).thenReturn(state);
      when(() => favoritesButtonBloc.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonBloc.add(any())).thenAnswer((_) async {});

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
      verify(() => favoritesButtonBloc.add(const AddFavorite(url)));
    });

    testWidgets('should see correct favorite icon and label when a favorite',
        (tester) async {
      const url = 'a.png';
      const state = FavoriteButtonState(
        currentImage: url,
        favorites: ['a.png'],
      );
      when(() => favoritesButtonBloc.state).thenReturn(state);
      when(() => favoritesButtonBloc.stream)
          .thenAnswer((_) => Stream.value(state));
      when(() => favoritesButtonBloc.add(any())).thenAnswer((_) async {});

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
      verify(() => favoritesButtonBloc.add(const RemoveFavorite(url)));
    });
  });
}
