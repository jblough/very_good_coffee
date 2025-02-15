import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();

  setUp(() {
    reset(repository);

    // Default values
    when(repository.initialize).thenAnswer((_) async {});
    when(() => repository.favorites)
        .thenAnswer((_) => Stream<List<String>>.value([]));
    when(() => repository.currentImage)
        .thenAnswer((_) => Stream<String?>.value('image-test'));
    when(repository.loadFavorites).thenAnswer((_) async {});
  });

  Widget generateWidget(String url) => addProviders(
        FavoriteButton(url: url),
        coffeeRepository: repository,
      );

  group('FavoritesButton tests', () {
    testWidgets(
        'should see correct favorite icon and label when not a favorite',
        (tester) async {
      const url = 'b.png';
      when(() => repository.favorites)
          .thenAnswer((_) => Stream<List<String>>.value(['a.png']));
      when(() => repository.currentImage)
          .thenAnswer((_) => Stream<String?>.value(url));
      when(() => repository.addFavorite(url)).thenAnswer((_) async {});

      final widget = generateWidget(url);
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Add this image to your list of favorite images');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite_outline);

      // Tap on the button to add to favorites
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      verify(() => repository.addFavorite(url));
    });

    testWidgets('should see correct favorite icon and label when a favorite',
        (tester) async {
      const url = 'a.png';
      when(() => repository.favorites)
          .thenAnswer((_) => Stream<List<String>>.value([url]));
      when(() => repository.currentImage)
          .thenAnswer((_) => Stream<String?>.value(url));
      when(() => repository.removeFavorite(any())).thenAnswer((_) async {});

      final widget = generateWidget(url);
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();
      final button = tester.widget(find.byType(FloatingActionButton))
          as FloatingActionButton;
      expect(button.tooltip, 'Remove this image from your list of favorites');
      final icon = tester.widget(find.byType(Icon)) as Icon;
      expect(icon.icon, Icons.favorite);

      // Tap on the button to remove from favorites
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      verify(() => repository.removeFavorite(url));
    });
  });
}
