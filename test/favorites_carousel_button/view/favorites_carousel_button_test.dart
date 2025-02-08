import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();
  final favoritesCarouselButtonCubit = MockFavoritesCarouselButtonCubit();

  setUp(() {
    reset(repository);
    reset(favoritesCarouselButtonCubit);

    // Default values
    when(() => repository.currentImage).thenAnswer((_) => Stream.value(null));
    when(repository.refreshImage).thenAnswer((_) async {});

    when(() => favoritesCarouselButtonCubit.state)
        .thenReturn(const FavoritesCarouselButtonState());
    when(() => favoritesCarouselButtonCubit.stream).thenAnswer(
      (_) => Stream.value(const FavoritesCarouselButtonState()),
    );
    when(favoritesCarouselButtonCubit.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        const FavoritesCarouselButton(),
        coffeeRepository: repository,
        favoritesCarouselButtonCubit: favoritesCarouselButtonCubit,
      );

  group('FavoritesCarouselButton tests', () {
    testWidgets('should see favorites carousel button when there are favorite',
        (tester) async {
      const favorites = ['a.png'];
      const state = FavoritesCarouselButtonState(favorites: favorites);
      when(() => favoritesCarouselButtonCubit.state).thenReturn(state);
      when(() => favoritesCarouselButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      when(() => repository.favorites)
          .thenAnswer((_) => Stream.value(favorites));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
        'should not see favorites carousel button when there are no favorites',
        (tester) async {
      when(() => repository.favorites).thenAnswer((_) => Stream.value([]));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('should open favorites carousel when tapped', (tester) async {
      const favorites = ['a.png'];
      const state = FavoritesCarouselButtonState(favorites: favorites);
      when(() => favoritesCarouselButtonCubit.state).thenReturn(state);
      when(() => favoritesCarouselButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      when(() => repository.favorites)
          .thenAnswer((_) => Stream.value(favorites));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FavoritesCarousel), findsNothing);

      // Tap on the button to open the carousel
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesCarousel), findsOneWidget);

      // Close the carousel
      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify that the carousel closed
      expect(find.byType(FavoritesCarousel), findsNothing);
    });

    testWidgets('should close favorites carousel when tapped twice',
        (tester) async {
      const favorites = ['a.png'];
      const state = FavoritesCarouselButtonState(favorites: favorites);
      when(() => favoritesCarouselButtonCubit.state).thenReturn(state);
      when(() => favoritesCarouselButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      when(() => repository.favorites)
          .thenAnswer((_) => Stream.value(favorites));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FavoritesCarousel), findsNothing);

      // Tap on the button to open the carousel
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesCarousel), findsOneWidget);

      // Close the carousel by tapping a second time
      await tester.tap(find.byType(FloatingActionButton), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify that the carousel closed
      expect(find.byType(FavoritesCarousel), findsNothing);
    });
  });
}
